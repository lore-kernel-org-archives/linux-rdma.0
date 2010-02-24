From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] dapl-2.0.27 and compat-dapl-1.2.16 release
Date: Wed, 24 Feb 2010 09:19:53 +0200
Message-ID: <4B84D319.6070605@dev.mellanox.co.il>
References: <E3280858FA94444CA49D2BA02341C983B59811C2@orsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E3280858FA94444CA49D2BA02341C983B59811C2-osO9UTpF0URZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ofw_list <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jimmy Hill <jimmy.hill-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Davis, Arlin R wrote:
>  
> New release for uDAPL v2.0 (2.0.23) and v1.2 (1.2.16) available at:
> 
> http://www.openfabrics.org/downloads/dapl
> 
> Latest Packages (see ChangeLog for details):
> 
> md5sum: e0995e0f9bc416a8478720953fa1cc63 compat-dapl-1.2.16.tar.gz 
> md5sum: 999734fc1f2e27b5fc98dd6fd486daf9 dapl-2.0.27.tar.gz 
> 
> Vlad, please pull into OFED 1.5.1:
> 
> For 1.2 and 2.0 support on same system, including development, install RPM packages as follow: 
> 
> dapl-2.0.27-1 
> dapl-utils-2.0.27-1 
> dapl-devel-2.0.27-1 
> dapl-debuginfo-2.0.27-1 
> compat-dapl-1.2.16-1 
> compat-dapl-devel-1.2.16-1 
> 
> Summary of changes: 
> 
> Release 2.0.27 fixes: 
> - windows: add scm makefile 
> - Windows does not require rdma_cma_abi.h, move the include from common code 
> - Windows patch to fix IB_INVALID_HANDLE name collision 
> - scm: dat_ep_connect fails on 32bit servers 
> - undefined symbol: dapls_print_cm_list 
> - Cleanup CM object lock before freeing CM object memory 
> - destroy verbs completion channels created via ia_open or ep_create. 
> - Update Copyright file and include the 3 license files in distribution 
> - When copying private_data out of rdma_cm events, use the 
> - dapl/cma: fix referencing freed address 
> - dapl: move close device after async thread is done 
> 
> Release 1.2.16 fixes: 
> - Update Copyright file and include the 3 license files in distribution 
> - cma: max sge incorrectly decremented during ibv_device_query 
> 
> Thanks,
> 
> -arlin
> 
> 

Hi Arlin,
Rpmbuild for compat-dapl fails:

# rpmbuild -ts --nodeps --define '_topdir /tmp/vlad/topdir' /tmp/vlad/compat-dapl/compat-dapl-1.2.16.tar.gz
error: %changelog not in descending chronological order

The reason is the following typo (wrong year):

%changelog
* Tue Feb 23 2009 Arlin Davis <ardavis-+/W+9+QloQG75v1z/vFq2g@public.gmane.org> - 1.2.16

Should be:
%changelog
* Tue Feb 23 2010 Arlin Davis <ardavis-+/W+9+QloQG75v1z/vFq2g@public.gmane.org> - 1.2.16


Regards,
Vladimir


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
