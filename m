From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Tue, 24 May 2016 16:02:04 +0000
Message-ID: <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hefty, Sean
...
> 
> The following is a sketch, or outline, for an ioctl framework.
> The purpose of the patch is to drive discussion and feedback on various design
> decisions rather than low-level comments on the code, so that the changes can
> be incorporated earlier in the development cycle.  The code is entirely untested
> and some functionality is not coded.
> 

This approach focuses on facilities for arbitrary device-specific objects (which could basically fit GPUs, NVMe, whatever...), while our primary goals are to replace write() with ioctl() and strive for a common *rdma* object model. 

In contrast, the patchset [1], focuses on the task at hand. The emphasis is on a common framework for parsing and parameter validation. It follows the agreed-upon concepts such as a single ioctl request code for common objects, natural mapping of the existing object mode (and hence easier backporting), typed attributes for extending the objects to accommodate multiple vendor features, and a unique ioctl request code for vendor-specific commands.
--Liran

[1] http://permalink.gmane.org/gmane.linux.drivers.rdma/36984
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
