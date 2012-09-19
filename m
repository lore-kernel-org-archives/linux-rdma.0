From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: how to preserve QP over HA events for librdmacm applications
Date: Wed, 19 Sep 2012 19:22:43 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8E527@ORSMSX101.amr.corp.intel.com>
References: <5059E82E.9020600@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237346A8E418@ORSMSX101.amr.corp.intel.com>
 <5059EA48.1040407@mellanox.com>
 <A4E971F4031F1840BBA6E79B417E62E82CF29C3B@MTRDAG01.mtl.com>
 <46C75A5F-AD9F-45CF-A441-B7D5F60709D8@ornl.gov>
 <1828884A29C6694DAF28B7E6B8A8237346A8E47E@ORSMSX101.amr.corp.intel.com>
 <86756672-ADCC-4EF0-A24C-19C4A0EB8188@ornl.gov>
 <16AD9776-40CA-4106-8F3D-A974067EEE2A@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <16AD9776-40CA-4106-8F3D-A974067EEE2A-1Heg1YXhbW8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I don't know if it matters to the conversation or not, but I use an SRQ. I am
> unclear how to remove a QP from the SRQ. Is ibv_destroy_qp() sufficient? Or do
> I need to use rdma_destroy_qp()?

rdma_destroy_qp() is a wrapper around ibv_destroy_qp(), plus destroys any internally allocated resources, like CQs, if the rdma_cm allocated those for the user.  If you called ibv_create_cq yourself, either is sufficient.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
