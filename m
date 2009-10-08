From: Jeremy Enos <jenos-R3uSp7q5utt4piUD7e9S/g@public.gmane.org>
Subject: 1.5 rc 1 install/build error
Date: Thu, 08 Oct 2009 18:01:45 -0500
Message-ID: <4ACE6F59.90502@ncsa.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is the HPC build option:

-------------------------------------------------------<snip>
/var/tmp/mvapich-1.1.0-3390-root/usr/mpi/gcc/mvapich-1.1.0/bin/mpicc -o
cpi cpi.o -lm
/var/tmp/mvapich-1.1.0-3390-root/usr/mpi/gcc/mvapich-1.1.0/bin/mpif77
-fPIC -L/usr/lib64 -Wall -c pi3.f
/var/tmp/mvapich-1.1.0-3390-root/usr/mpi/gcc/mvapich-1.1.0/bin/mpif77 -o
pi3 pi3.o
/var/tmp/mvapich-1.1.0-3390-root/usr/mpi/gcc/mvapich-1.1.0/bin/mpif90 
-Wall -c pi3f90.f90
/var/tmp/mvapich-1.1.0-3390-root/usr/mpi/gcc/mvapich-1.1.0/bin/mpif90     
-o pi3f90 pi3f90.o
rm -f *.o *~ PI* cpi  pi3 simpleio hello++ pi3f90 cpilog
rm -rf SunWS_cache ii_files pi3f90.f pi3p cpip *.ti *.ii
installed MPICH in
/var/tmp/mvapich-1.1.0-3390-root/usr/mpi/gcc/mvapich-1.1.0
/var/tmp/mvapich-1.1.0-3390-root/usr/mpi/gcc/mvapich-1.1.0/sbin/mpiuninstall
may be used to remove the installation.
+ rm -f
/var/tmp/mvapich-1.1.0-3390-root//usr/mpi/gcc/mvapich-1.1.0/share/examples/mpirun
+ cat
+ cat
+ /usr/lib/rpm/redhat/brp-compress
+ /usr/lib/rpm/redhat/brp-strip /usr/bin/strip
+ /usr/lib/rpm/redhat/brp-strip-static-archive /usr/bin/strip
+ /usr/lib/rpm/redhat/brp-strip-comment-note /usr/bin/strip /usr/bin/objdump
+ /usr/lib/rpm/brp-python-bytecompile
+ /usr/lib/rpm/redhat/brp-python-hardlink
+ /usr/lib/rpm/redhat/brp-java-repack-jars
Processing files: mvapich_gcc-1.1.0-3390
error: File not found:
/var/tmp/OFED_topdir/BUILDROOT/mvapich_gcc-1.1.0-3390.x86_64/usr/mpi/gcc/mvapich-1.1.0


RPM build errors:
    File not found:
/var/tmp/OFED_topdir/BUILDROOT/mvapich_gcc-1.1.0-33902.6.27.35-170.2.94.fc10.x86_64
.x86_64/usr/mpi/gcc/mvapich-1.1.0

-------------------------------------------------------

OS: Fedora Core 10 x64, up to date as of today
Kernel:  2.6.27.35-170.2.94.fc10.x86_64

This seems like more of a packaging problem than a build one.

    Jeremy

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
