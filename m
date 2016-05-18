From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: OFED release with RoCE v2 support
Date: Wed, 18 May 2016 15:22:37 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7DDBA58D@ORSMSX115.amr.corp.intel.com>
References: <BN4PR11MB094679B0C45AA332E6BEE7BBFF770@BN4PR11MB0946.namprd11.prod.outlook.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDB98D5@ORSMSX115.amr.corp.intel.com>
 <BN4PR11MB0946718DFF5ECF08958AC620FF490@BN4PR11MB0946.namprd11.prod.outlook.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7DDBA450@ORSMSX115.amr.corp.intel.com>
 <5a4ccdf6-94d9-3038-175d-e3500c7d3d13@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5a4ccdf6-94d9-3038-175d-e3500c7d3d13-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ameen Rahman <ameen.rahman-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>In this case, I expect you guys to be hurting hard when you try to do all the backports.  The problem is that in the last year we have made lots >of changes that depend on upstream kernel improvements both inside the RDMA stack and out.  I suspect this backport cycle may be worse >than those in the past.  But I could be wrong...

Yes, and of course it depends on which distro kernel we attempt to backport to. For the later model RHEL 7.x and SLES 12 kernels, it may not
be as bad, if those kernels have picked up the required upstream kernel improvements. I am however worried that it might be too hard to try to backport to a RHEL 6.x series kernel. We'll have to evaluate that once we start work on the next major OFED. 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
