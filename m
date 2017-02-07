From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: OFED-4.8, rdma-core, and library paths
Date: Tue, 7 Feb 2017 09:37:46 -0600
Message-ID: <01f401d28158$21b682c0$65238840$@opengridcomputing.com>
References: <011b01d28153$e5f0adf0$b1d209d0$@opengridcomputing.com> <5899D735.3060503@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5899D735.3060503-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Vladimir Sokolovsky' <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> > Thoughts?  Am I missing something in the OFED-4.8 installer that avoids this
> > issue?
> >
> >
> > Steve.
> 
> Hi Steve,
> OFED's install script uninstalls previous OFED versions and
> corresponding in-box RPMs as well.
> The list of in-box RPMs that should be uninstalled is maintained in the
> install.pl script itself. ofed_info is not used by the install.pl script.
> So, there should be no issue here.
> 

That's good!  I missed that.  I guess I was looking at uninstall.sh, and assumed
install.pl called that.  

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
