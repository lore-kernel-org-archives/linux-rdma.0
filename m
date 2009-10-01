From: Jeremy Enos <jenos-R3uSp7q5utt4piUD7e9S/g@public.gmane.org>
Subject: [Fwd: Re: [ofa-general] Fedora 10 OFED support plans]
Date: Thu, 01 Oct 2009 02:28:26 -0500
Message-ID: <4AC45A1A.3060905@ncsa.uiuc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060601070603050807040004"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060601070603050807040004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I don't want to become an annoyance with this issue, but it doesn't seem 
to be much of a concern that the ofed install script won't successfully 
run on Fedora 10.  From the looks of things below, it's a packaging 
issue, not a build issue.  Unless I'm doing something wrong- but it 
seems fairly straighforward to run the install script and build.
Please let me know if there's a different approach I should be taking 
with this problem (different list, bug submission, etc) that would be 
more appropriate, and most important to me, more likely to get fixed.  
If I want to continue using Fedora 10 and I want mvapich/verbs, etc- 
what are my options?  I'd really like to avoid rebuilding an entire 
machine from scratch to a new OS just to be able to bring in OFED.
thx-

    Jeremy

-------- Original Message --------
Subject: 	Re: [ofa-general] Fedora 10 OFED support plans
Date: 	Tue, 22 Sep 2009 16:30:09 -0500
From: 	Jeremy Enos <jenos-R3uSp7q5utt4piUD7e9S/g@public.gmane.org>
Organization: 	National Center for Supercomputing Applications
To: 	Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
CC: 	general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
References: 	<4A8E4854.2060909-R3uSp7q5utt4piUD7e9S/g@public.gmane.org> 
<20090910193454.GB7552-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> 
<4AA95AF8.9020905-R3uSp7q5utt4piUD7e9S/g@public.gmane.org> 
<200909131229.29887.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>



I think the problem I'm seeing isn't kernel related... it's a problem w/ 
the build process.  It's trying to write to a directory that hasn't been 
created yet in the build root.

The error:
/+ modsyms=/var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5/Module.symvers
+ for modsym in '$modsyms'
+ cat /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5/Module.symvers
/var/tmp/rpm-tmp.91zmLA: line 37: 
/var/tmp/OFED_topdir/BUILDROOT/ofa_kernel-1.5-ofed20090922.x86_64//usr/src/ofa_kernel/Module.symvers: 
No such file or directory
/
The script around line 37:
/modsyms=`find $RPM_BUILD_DIR/ofa_kernel-1.5 -name Module.symvers -o 
-name Modules.symvers`
for modsym in $modsyms
do
        cat $modsym >> $RPM_BUILD_ROOT//usr/src/ofa_kernel/Module.symvers
done
/
The actual filesystem state:
/[root@33 ofa_kernel-1.5-ofed20090922.x86_64]# pwd
/var/tmp/OFED_topdir/BUILDROOT/ofa_kernel-1.5-ofed20090922.x86_64
[root@33 ofa_kernel-1.5-ofed20090922.x86_64]# ls
lib
[root@33 ofa_kernel-1.5-ofed20090922.x86_64]#
/
Note the lack of a usr folder, hence the error.  Isn't anyone else 
running into this?

    Jeremy

Jack Morgenstein wrote:
> On Thursday 10 September 2009 23:00, Jeremy Enos wrote:
>   
>>  Fails w/ ofa_kernel like the others have... I didn't test excluding this rpm with FC11, but the others also fail elsewhere w/ this rpm excluded- so I'm guessing FC11 would as well.  I included the output (and last 50 lines of log) in case you can glean something useful from it.  Thank you-
>>  
>>      Jeremy
>>  
>>  Build ofa_kernel RPM
>>  Running rpmbuild --rebuild  --define '_topdir /var/tmp/OFED_topdir' --define 'configure_options   --with-core-mod --with-user_mad-mod --with-user_access-mod --with-addr_trans-mod --with-mthca-mod --with-mlx4-mod --with-mlx4_en-mod --with-cxgb3-mod --with-nes-mod --with-qib-mod --with-ipoib-mod --with-sdp-mod --with-rds-mod --with-qlgc_vnic-mod --with-iser-mod --with-nfsrdma-mod' --define 'build_kernel_ib 1' --define 'build_kernel_ib_devel 1' --define 'KVERSION 2.6.30.5-43.fc11.x86_64' --define 'K_SRC /lib/modules/2.6.30.5-43.fc11.x86_64/build' --define 'network_dir /etc/sysconfig/network-scripts' --define '_prefix /usr' --define '__arch_install_post %{nil}' /home-ib/ac/jenos/ofed/OFED-1.5-beta1/SRPMS/ofa_kernel-1.5-ofed1.5.beta1.src.rpm
>>  Failed to build ofa_kernel RPM 
>>  See /tmp/OFED.1584.logs/ofa_kernel.rpmbuild.log 
>>  [root@ac32 OFED-1.5-beta1]# tail -50 /tmp/OFED.1584.logs/ofa_kernel.rpmbuild.log 
>>                  mkdir -p /var/tmp/OFED_topdir/BUILDROOT/ofa_kernel-1.5-ofed1.5.beta1.x86_64//lib/modules/2.6.30.5-43.fc11.x86_64/updates/kernel/net/rds; \
>>                  mv /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5/lib/modules/2.6.30.5-43.fc11.x86_64/extra/net/rds/rds*.ko /var/tmp/OFED_topdir/BUILDROOT/ofa_kernel-1.5-ofed1.5.beta1.x86_64//lib/modules/2.6.30.5-43.fc11.x86_64/updates/kernel/net/rds/ ; \
>>          elif [ -d /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5/lib/modules/2.6.30.5-43.fc11.x86_64/extra ]; then \
>>                  mkdir -p /var/tmp/OFED_topdir/BUILDROOT/ofa_kernel-1.5-ofed1.5.beta1.x86_64//lib/modules/2.6.30.5-43.fc11.x86_64/updates/kernel/net/rds; \
>>                  mv /var/tmp/OFED_topdir/BUILD/ofa_kernel-1.5/lib/modules/2.6.30.5-43.fc11.x86_64/extra/rds*.ko /var/tmp/OFED_topdir/BUILDROOT/ofa_kernel-1.5-ofed1.5.beta1.x86_64//lib/modules/2.6.30.5-43.fc11.x86_64/updates/kernel/net/rds/ ; \
>>          fi;
>>     
>
> I notice that you have a 2.6.30-based kernel.  The FC11 that we have here is 2.6.29-based:
>       2.6.29.4-167.fc11.x86_64
>
> Has there been some change in FC11 that we are not aware of?
> (the release notes for FC11 also state that it is 2.6.29-based).
>
> That said, I notice that there is a bug in rds on our Fedora Core11 (2.6.29-based).
> Andy, you need to put rds_to_2_6_28.patch into a 2.6.29 kernel_patches/backports directory.
> There isn't one yet.
>
> I can do this for you, but I suggest a rename to rds_to_2_6_29.patch for the file (in this directory
> only).
> Summary:  I will create kernel_patches/backport/2.6.29 directory, and put rds_to_2_6_29.patch inside.
>           rds_to_2_6_29.patch is identical to rds_to_2_6_28.patch
>           NOTE: as of now, there is no need for a separate 2.6.29_FC11 backports directory.  If the need
>                 arises, we will create it.
>  
> If you ACK, I will take care of it.
>
> -Jack
>
>   

--------------060601070603050807040004
Content-Type: text/plain;
 name="Attached Message Part"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Attached Message Part"

_______________________________________________
general mailing list
general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general

To unsubscribe, please visit http://openib.org/mailman/listinfo/openib-general

--------------060601070603050807040004--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
