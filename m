From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/3] ibacm: check for special handling of loopback	requests
Date: Wed, 17 Nov 2010 10:33:53 +0200
Message-ID: <4CE39371.8030306@voltaire.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168CE@orsmsx501.amr.corp.intel.com>	<1289953873.2365.179.camel@chromite.mv.qlogic.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616939@orsmsx501.amr.corp.intel.com>	<1289956127.2365.190.camel@chromite.mv.qlogic.com>	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8616977@orsmsx501.amr.corp.intel.com> <1289957852.9693.7.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289957852.9693.7.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ralph Campbell wrote:
> I guess what I'm objecting to is hard coding mlx4. I was trying to think of a way that would allow other HCAs to support the block loopback option in the future. It looks like ipoib sets IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK for kernel QPs but this isn't defined in libibverbs yet. It seems reasonable to add that feature some time in the future and change ibacm to use it. In the mean time, I guess I don't see an alternative to your patch.
Ralph, Sean

Its been couple of years since some folks from Voltaire tried to push 
this flag and the grounds for adding similar flags for QP creation, on 
the bright side, its there for kernel consumers where existing flags are 
LSO, block-multicast-loopback. On the somehow disappointing side, we 
didn't get that merged for user space. Basically, there was a claim on 
dependency with  XRC patch set which also added flags for QPs, at some 
point, Ron Livne managed to introduce patch set which is independent of 
the XCR, see (*) below, but it didn't get in. As such one of our 
application teams pushed to ofed that mlx4 patch which sets this bit by 
default and the acm code is trying to identify and act upon its 
existence (**)


Or.

(*) latest post of the patch set

0/4: https://kerneltrap.org/mailarchive/openfabrics-general/2008/12/11/4392994
1/4: https://kerneltrap.org/mailarchive/openfabrics-general/2008/12/11/4393054
2/4: https://kerneltrap.org/mailarchive/openfabrics-general/2008/12/11/4393004
3/4: https://kerneltrap.org/mailarchive/openfabrics-general/2008/12/11/4393014
4/4: https://kerneltrap.org/mailarchive/openfabrics-general/2008/12/11/4393024

(**) ofed patch
http://git.openfabrics.org/git?p=ofed_1_5/linux-2.6.git;a=blob;f=kernel_patches/fixes/mlx4_0290_mcast_loopback.patch;h=786a3926529befac2c2d1fa6d8c36bada79d61a7;hb=HEAD <http://git.openfabrics.org/git?p=ofed_1_5/linux-2.6.git;a=blob;f=kernel_patches/fixes/mlx4_0290_mcast_loopback.patch;h=786a3926529befac2c2d1fa6d8c36bada79d61a7;hb=HEAD>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
