import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shareme/core/theme/app_colors.dart';
import 'package:shareme/core/theme/app_spacing.dart';
import 'package:shareme/core/theme/app_typography.dart';
import 'package:path_provider/path_provider.dart';

class DebugLogsScreen extends StatefulWidget {
  const DebugLogsScreen({super.key});

  @override
  State<DebugLogsScreen> createState() => _DebugLogsScreenState();
}

class _DebugLogsScreenState extends State<DebugLogsScreen> {
  String _logs = "Loading logs...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (Platform.isAndroid) {
        // -d: dump and exit
        // -v time: include timestamps
        final result = await Process.run('logcat', ['-d', '-v', 'time']);
        setState(() {
          _logs = result.stdout as String;
          if (_logs.isEmpty) {
            _logs = "No logs found or logcat is empty.";
          }
        });
      } else {
        setState(() {
          _logs = "Logcat is only available on Android.";
        });
      }
    } catch (e) {
      setState(() {
        _logs = "Failed to fetch logs: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _exportLogs() async {
    try {
      final directory = await getExternalStorageDirectory();
      final downloadsDir = Directory('/storage/emulated/0/Download');
      final path = downloadsDir.existsSync() ? downloadsDir.path : directory?.path;
      
      if (path != null) {
        final file = File('$path/shareme_debug_logs_${DateTime.now().millisecondsSinceEpoch}.txt');
        await file.writeAsString(_logs);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logs saved to ${file.path}'),
              backgroundColor: AppColors.accentSignal,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save logs: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        title: const Text('Production Debug Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _fetchLogs,
            tooltip: 'Refresh Logs',
          ),
          IconButton(
            icon: const Icon(Icons.download_rounded),
            onPressed: _exportLogs,
            tooltip: 'Export to Downloads',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accentPulse))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: SelectableText(
                _logs,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
    );
  }
}
