From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: IBUTILS PATCH SHOULD BE REMOVED: ibutils patch
 f3cf1f7c15ca24598fdf68b9ba71788b386b2f14 introduces syntax errors into
 ibdiagpath
Date: Thu, 17 Feb 2011 15:35:06 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28910@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yevgeny,

I've got users complaining about ibdiagpath failing.  When I dug into it I found that patch f3cf1f7c15ca24598fdf68b9ba71788b386b2f14 is syntactically incorrect and needs to be rolled back.

The problem is that the patch contains lines like

    set entry [lindex $values $i+1]

these lines aren't valid TCL - this particular line causes ibdiagpath to fail with:

    -I---------------------------------------------------
    -I- QoS on Path Check
    -I---------------------------------------------------
    bad index "0+1": must be integer or end?-integer?

Removing patch f3cf1f7c15ca24598fdf68b9ba71788b386b2f14 allows ibdiagpath to complete.

Original patch:
------------------

diff --git a/ibdiag/src/ibdebug.tcl b/ibdiag/src/ibdebug.tcl
index 2f2c0af..b25bc8a 100644
--- a/ibdiag/src/ibdebug.tcl
+++ b/ibdiag/src/ibdebug.tcl
@@ -161,7 +161,7 @@ proc InitializeIBDIAG {} {
     global G argv argv0 InfoArgv INFO_LST MASK

     ### InitializeIBDIAG - Set general vars
-    set G(var:version.num)          1.5.5
+    set G(var:version.num)          1.5.6
     set G(var:tool.name)            [file rootname [file tail $argv0]]
     set G(var:start.clock.seconds)  [clock seconds]
     set G(var:desc.local.dev)       "The Local Device"
@@ -3903,7 +3903,7 @@ proc CheckPathQoS {paths} {
        foreach {tbl numEntries values} $lowHighCtrl {
            set overRangeVLs {}
            for {set i 0} {$i < $numEntries} {incr i} {
-               set entry [lindex $values $i]
+               set entry [lindex $values $i+1]
                set vl [expr [lindex $entry 0]]
                set weight [lindex $entry 1]
                if {$vl >= $opVLs} {
@@ -3936,8 +3936,8 @@ proc CheckPathQoS {paths} {
        for {set i 0} {$i < 8} {incr i} {
            set sl0 [expr 2*$i]
            set sl1 [expr 2*$i + 1]
-           set vl0 [expr ([lindex $SL2VL $i] & 0xf0) >> 4]
-           set vl1 [expr [lindex $SL2VL $i] & 0xf]
+           set vl0 [expr ([lindex $SL2VL $i+1] & 0xf0) >> 4]
+           set vl1 [expr [lindex $SL2VL $i+1] & 0xf]
            if {($vl0 >= $opVLs) || ($vl0 == 15)} {
                set BLOCKED_SL($sl0) 1
                lappend outOfRangeVLsSLs $sl0

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
