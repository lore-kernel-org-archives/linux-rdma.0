From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: kitten - mlx4: Unhandled interrupt - owner bit
Date: Wed, 10 Mar 2010 18:35:21 +0200
Message-ID: <20100310163521.GB18440@mtldesk030.lab.mtl.com>
References: <4B97B4BE.1050809@hpce.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B97B4BE.1050809-e+cCxrzAqRFWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fredrik Unger <funger-e+cCxrzAqRFWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 10, 2010 at 04:03:26PM +0100, Fredrik Unger wrote:
> 
> When investigating the error it seems to stem from next_eqe_sw in drivers/net/mlx4/eq.c
> called by the interrupt handler.
> What happens is that (eqe->owner & 0x80) is true causing the routine to return
> NULL resulting in an unhandled interrupt (eg the interrupt routine returns 0)

Please note that the condition is a bit more complicated. I quote the
whole function:

static struct mlx4_eqe *next_eqe_sw(struct mlx4_eq *eq)
{
        struct mlx4_eqe *eqe = get_eqe(eq, eq->cons_index);
        return !!(eqe->owner & 0x80) ^ !!(eq->cons_index & eq->nent) ? NULL : eqe;
}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
