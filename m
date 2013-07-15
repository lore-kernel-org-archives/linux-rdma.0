From: Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ibdiagnet: ibdiagnet /tmp clobbering vulnerability
Date: Mon, 15 Jul 2013 21:34:30 +0530
Message-ID: <51E41D8E.4040503@oracle.com>
References: <51E3865C.7080105@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E3865C.7080105-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rajkumar Sivaprakasam <rajkumar.sivaprakasam-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Copying Rajkumar. Rajkumar is also in on this alias.

Thanks
    Pramod
> Sending this on behalf of Rajkumar Sivaprakasam.
>
>   Pramod
> <--------------------------------------------------------------------------------------> 
>
>
> The diff of the proposed changes for fixing the CVE 2013-2561 is in
> the  attachment to this mail. The diffs are based on 
> ~kliteyn/ibutils.git.
> Please review the proposed changes for the fix. See below for the
> details about the issue and the proposed fix.
>
> Synopsis:
>      CVE-2013-2561: ibdiagnet /tmp clobbering vulnerability
>
> Problem statement:
>      The ibdiagnet  utility creates many files in the /tmp/ directory.
> If  any  of  these  files  exist  already,  they  are  deleted during
> initialization of the command except for,
>
>      ibdiagnet.log
>      ibdiagnet.db
>      ibdiagnet_ibis.log
>
>      These files, if  present, are  truncated to zero  length  and the
> relevant data written to it.
>
>      A malicious user (non-privileged) can create a soft link with one
> or more of the above three files pointing to an important  system file
> (example /etc/shadow), since /tmp/ has write  access by  everyone. The
> next time  ibdiagnet  is  run  as root, the command will just open the
> symlink  truncating the system file and  writing the ibdiagnet data in
> those file, possibly bringing down the system.
>
> Fix Summary:
>      Remove  the  above  files  too  in a way that does not impair the
> functionality.  This  breaks  any  symlink  that  was  created  by the
> malicious user  preventing the data  corruption. Since these files are
> always  opened  with  the  access  mode 'w'  (write,  with  file size
> truncated  to  0)  it  is  safe  to delete these files and treats them
> similar to the other files.
>
> Fix Details:
>      The  ibdiagnet  utility  at  the  initialization path of the code
> (StartIBDIAG() in  ibdebug.tcl) calls  DeleteOldFiles()  routine which
> deletes  all  the  files  that will be created by the utility, if they
> already  exist. This  routine  however  skips  the  ibdiagnet.log and
> ibdiagnet.db files.
>
>      The  ibdiagnet.log  file  is  opened  as soon as the command line
> arguments  are  parsed  (in  ParseArgv())  much  before StartIBDIAG()
> routine is executed. This is done to log any errors encountered during
> the early  initialization phase. If the  DeleteOldFiles()  deletes the
> log file  latter, the  utility will  continue to write to the file but
> the  entry  will  be  removed  from  the directory name space. It will
> likely be deleted (inode and disk blocks) once we close the file. This
> is  the  reason  DeleteOldFiles()  explicitly  skips  this  file. The
> proposed  fix  deletes any pre-existing file with the same name before
> the file is opened for logging in ParseArgv().
>
>      The  ibdiagnet.db  file  contains  the IB  subnet database in tcl
> source-able  array  format. This  file  can be used latter to load the
> subnet database without going  through the subnet discovery phase. The
> sourcing of the subnet database file is done after the DeleteOldFiles()
> routine  is   executed.  So  if  the   input   file  is  the default
> /tmp/ibdiagnet.db  file and if we  delete it, then the sourcing of the
> subnet database will fail. To  prevent this  from happening, currently
> the  subnet  database  file is explicitly skipped by DeleteOldFiles().
> This  opens the  window for  the symlink based system  file clobbering
> when the  file is  written. The  fix is  to  delete  the ibdiagnet.db
> file  just  before  opening for  write. The  file  is  deleted only if
> -load_db  option is not given, since we do not want to delete the file
> unless  we  have done  subnet discovery and need to write out the new
> subnet database.
>
>      The  ibdiagnet_ibis.log is the log file setup for IB interactive
> scripting  interpreter (ibis) to log its  messages. This  is done very
> early in InitializeIBIS(). Also, this is not part of the list of files
> maintained  by   ibdiagnet   utility.  Hence  it  is  not  deleted by
> DeleteOldFiles().  The  fix  is  to  delete the file just before it is
> setup by ibdiagnet for ibis.
>
>
> Thanks
> Raj

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
