From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: RE: failure to get gid with rdma_bind_addr with >= 3.10 kernels
Date: Mon, 11 Nov 2013 17:09:23 +0000
Message-ID: <000001424823a106-9987eb8d-3510-4c00-bb36-e03f4deda522-000000@email.amazonses.com>
References: <527F6896.1080802@mellanox.com> <527F69B1.9070701@mellanox.com> <527F6A8F.1030506@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237388CF6F30@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CF6F30-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 11 Nov 2013, Hefty, Sean wrote:

> > On 10/11/2013 13:10, Or Gerlitz wrote:
> > > So somewhere between 3.10 and 3.11
> > between 3.10 and 3.12
>
> I'll take a look.
>
> What is the impact to the application?

Application will run with MOFED 2.0/OFED 1.5.3 but wont start with Linux
3.12.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
