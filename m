From: Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: ibdiagnet: ibdiagnet /tmp clobbering vulnerability
Date: Mon, 15 Jul 2013 10:49:24 +0530
Message-ID: <51E3865C.7080105@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070809000502040601060507"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------070809000502040601060507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sending this on behalf of Rajkumar Sivaprakasam.

   Pramod
<--------------------------------------------------------------------------------------> 


The diff of the proposed changes for fixing the CVE 2013-2561 is in
the  attachment to this mail. The diffs are based on ~kliteyn/ibutils.git.
Please review the proposed changes for the fix. See below for the
details about the issue and the proposed fix.

Synopsis:
      CVE-2013-2561: ibdiagnet /tmp clobbering vulnerability

Problem statement:
      The ibdiagnet  utility creates many files in the /tmp/ directory.
If  any  of  these  files  exist  already,  they  are  deleted during
initialization of the command except for,

      ibdiagnet.log
      ibdiagnet.db
      ibdiagnet_ibis.log

      These files, if  present, are  truncated to zero  length  and the
relevant data written to it.

      A malicious user (non-privileged) can create a soft link with one
or more of the above three files pointing to an important  system file
(example /etc/shadow), since /tmp/ has write  access by  everyone. The
next time  ibdiagnet  is  run  as root, the command will just open the
symlink  truncating the system file and  writing the ibdiagnet data in
those file, possibly bringing down the system.

Fix Summary:
      Remove  the  above  files  too  in a way that does not impair the
functionality.  This  breaks  any  symlink  that  was  created  by the
malicious user  preventing the data  corruption. Since these files are
always  opened  with  the  access  mode 'w'  (write,  with  file size
truncated  to  0)  it  is  safe  to delete these files and treats them
similar to the other files.

Fix Details:
      The  ibdiagnet  utility  at  the  initialization path of the code
(StartIBDIAG() in  ibdebug.tcl) calls  DeleteOldFiles()  routine which
deletes  all  the  files  that will be created by the utility, if they
already  exist. This  routine  however  skips  the  ibdiagnet.log and
ibdiagnet.db files.

      The  ibdiagnet.log  file  is  opened  as soon as the command line
arguments  are  parsed  (in  ParseArgv())  much  before StartIBDIAG()
routine is executed. This is done to log any errors encountered during
the early  initialization phase. If the  DeleteOldFiles()  deletes the
log file  latter, the  utility will  continue to write to the file but
the  entry  will  be  removed  from  the directory name space. It will
likely be deleted (inode and disk blocks) once we close the file. This
is  the  reason  DeleteOldFiles()  explicitly  skips  this  file. The
proposed  fix  deletes any pre-existing file with the same name before
the file is opened for logging in ParseArgv().

      The  ibdiagnet.db  file  contains  the IB  subnet database in tcl
source-able  array  format. This  file  can be used latter to load the
subnet database without going  through the subnet discovery phase. The
sourcing of the subnet database file is done after the DeleteOldFiles()
routine  is   executed.  So  if  the   input   file  is  the default
/tmp/ibdiagnet.db  file and if we  delete it, then the sourcing of the
subnet database will fail. To  prevent this  from happening, currently
the  subnet  database  file is explicitly skipped by DeleteOldFiles().
This  opens the  window for  the symlink based system  file clobbering
when the  file is  written. The  fix is  to  delete  the ibdiagnet.db
file  just  before  opening for  write. The  file  is  deleted only if
-load_db  option is not given, since we do not want to delete the file
unless  we  have done  subnet discovery and need to write out the new
subnet database.

      The  ibdiagnet_ibis.log is the log file setup for IB interactive
scripting  interpreter (ibis) to log its  messages. This  is done very
early in InitializeIBIS(). Also, this is not part of the list of files
maintained  by   ibdiagnet   utility.  Hence  it  is  not  deleted by
DeleteOldFiles().  The  fix  is  to  delete the file just before it is
setup by ibdiagnet for ibis.


Thanks
Raj

--------------070809000502040601060507
Content-Type: text/x-patch;
 name="ibdiagnet_CVE-2013-2561.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ibdiagnet_CVE-2013-2561.patch"

>From eef53577ad675b0ffbfd7b47aa58f7170c0fab11 Mon Sep 17 00:00:00 2001
From: Rajkumar Sivaprakasam <rajkumar.sivaprakasam-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Date: Thu, 11 Jul 2013 02:46:36 -0700
Subject: [PATCH] ibdiagnet /tmp clobbering vulnerability CVE-2013-2561

---
 ibdiag/src/ibdebug.tcl    |   25 +++++++++++++++++++------
 ibdiag/src/ibdebug_if.tcl |   18 ++++++++++++++++++
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/ibdiag/src/ibdebug.tcl b/ibdiag/src/ibdebug.tcl
index 1527f9e..9bf473d 100644
--- a/ibdiag/src/ibdebug.tcl
+++ b/ibdiag/src/ibdebug.tcl
@@ -352,13 +352,16 @@ proc InitializeIBIS {} {
     if {[file exists $ibisOutDir/$ibisLogFile] && (![file writable $ibisOutDir/$ibisLogFile])} {
 	set ibisLogFile $ibisLogFile.[pid]
     }
+
+    ## Check if the file exists. If it does delete it. The log file is opened with the 'w' access
+    ## mode which truncates the file to zero length, so the contents are not preserved. Deleting
+    ## the file prevents any softlink based system file clobbering issues.
     if {[file exists $ibisOutDir/$ibisLogFile]} {
-	if {![file writable $ibisOutDir/$ibisLogFile]} {
-	    if {![file writable $ibisOutDir/$ibisLogFile]} {
-		catch {set ibisLogFd [open $ibisOutDir/$ibisLogFile w]} errMsg
-		inform "-E-ibis:file.not.writable" -value $ibisOutDir/$ibisLogFile -errMsg $errMsg
-	    }
-	}
+        ## Since we have already verified the directory is writable and open with 'w' option
+        ## truncates the file, it is safe to delete the file if it exists.
+        if {[catch {file delete $ibisOutDir/$ibisLogFile} errMsg]} {
+            inform "-E-ibis:could.not.delete.file" -value $ibisOutDir/$ibisLogFile
+        }
     }
     inform "-V-ibis.ibis.log.file" -value $ibisOutDir/$ibisLogFile
 
@@ -5123,6 +5126,16 @@ proc writeDBFile {} {
         return 1
     }
 
+    ## If the file exists delete the file to prevent any symlink
+    ## system file clobbering. The file is about to be opened with
+    ## the access mode of 'w', which will truncate the file to zero
+    ## length anyway. So, it is safe to delete the file now.
+    if {[file exists $G(outfiles,.db)]} {
+        if {[catch {file delete $G(outfiles,.db)} errMsg]} {
+           return 1
+        }
+    }
+
     set FileID [InitializeOutputFile $G(var:tool.name).db]
 
     foreach {array_name data} {G data* Neighbor *} {
diff --git a/ibdiag/src/ibdebug_if.tcl b/ibdiag/src/ibdebug_if.tcl
index f0586a1..5cddb6b 100644
--- a/ibdiag/src/ibdebug_if.tcl
+++ b/ibdiag/src/ibdebug_if.tcl
@@ -675,6 +675,16 @@ proc ParseArgv {} {
     }
 
     ## Command line check - Test5.0: log file
+
+    ## The directory has been verified to be writable, delete the file if it exists since
+    ## we anyway open it with 'w' which will truncate it to zero length. Deleting the file
+    ## will prevent symlink based system file clobbering.
+    if {[file exists $G(outfiles,.log)]} {
+        if {[catch {file delete $G(outfiles,.log)} errMsg]} {
+            ## Print the delete failure error message and exit
+            inform "-E-loading:cannot.delete.file" $G(outfiles,.log) -fn $G(outfiles,.log) -errMsg $errMsg
+        }
+    }
     if {[catch {set G(logFileID) [open $G(outfiles,.log) w]} errMsg]} {
 	 inform "-E-loading:cannot.open.file" $G(outfiles,.log) -fn $G(outfiles,.log) -errMsg $errMsg
     }
@@ -1229,6 +1239,10 @@ proc inform { msgCode args } {
 	    append msgText "IBIS: The following file is write protected: $msgF(value)%n"
 	    append msgText "Error message: \"$msgF(errMsg)\""
 	}
+	"-E-ibis:could.not.delete.file" {
+	    append msgText "IBIS: Could not delete the file : $msgF(value)%n"
+	    append msgText "Error message: \"$msgF(errMsg)\""
+	}
 	"-V-ibis:ibis_get_local_ports_info" {
 	    append msgText "IBIS: ibis_get_local_ports_info:%n$msgF(value)"
 	}
@@ -1260,6 +1274,10 @@ proc inform { msgCode args } {
 	    append msgText "Failed to load ibdiag external DB from: $msgF(fn)%n"
 	    append msgText "Error message: \"$msgF(errMsg)\""
 	}
+	"-E-loading:cannot.delete.file" {
+	    append msgText "Could not delete the file : $msgF(fn)%n"
+	    append msgText "Error message: \"$msgF(errMsg)\""
+	}
         "-W-loading:old.osm.version" {
 	    append msgText "OSM: The current OSM version is not up-to-date"
 	}
-- 
1.7.9.2


--------------070809000502040601060507--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
