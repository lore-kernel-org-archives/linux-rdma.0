From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Wed, 21 Oct 2015 21:52:54 +0300
Message-ID: <CAJ3xEMigVzieLM1TGU4Y5Nyoj1NdG2hEcs9YFWyN9evQUjL3uA@mail.gmail.com>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
	<1444909482-17113-2-git-send-email-eranbe@mellanox.com>
	<56276095.6020803@dev.mellanox.co.il>
	<56276336.7000704@mellanox.com>
	<56279CA4.8040201@dev.mellanox.co.il>
	<CAJ3xEMgWcpKbKL3jhiK2RP=H6_iY0eriirAXn1TJaSG7u8frAA@mail.gmail.com>
	<alpine.DEB.2.20.1510211319520.10833@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1510211319520.10833-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 9:21 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:

> Hmmm... We are running out of dev_cap flags on mlx4 already. They are 32
> bits.

Christoph,

These  are QP creation flags (IB_QP_CREATE_XXX) not device capability
flags (IB_DEVICE_YYY)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
