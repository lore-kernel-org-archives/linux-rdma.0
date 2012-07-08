From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V1 10/29] net/mlx4_core: Implement mechanism
 for reserved qkeys
Date: Sun, 8 Jul 2012 18:17:38 +0300
Message-ID: <4FF9A492.6090803@mellanox.com>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il> <1340094121-14858-11-git-send-email-jackm@dev.mellanox.co.il> <CAL1RGDVXTWs6Xi2JQ=7-RiZUePfc6SoUsCHHdbS9XLUQyim6UA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVXTWs6Xi2JQ=7-RiZUePfc6SoUsCHHdbS9XLUQyim6UA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/6/2012 2:26 AM, Roland Dreier wrote:
> Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> For security reasons (i.e., to prevent guests from sending MADs to tunnel QPs
>> belonging to other guests), each proxy-tunnel qp pair is assigned a unique,
>> reserved, qkey.  These qkeys are available only for proxy and tunnel qp's --
>> if the guest tries to use these qkeys with other qp's, it will fail.
>
> How does a guest OS know which Q_Key it's allowed to use?  I understand
> you stick the reserved Q_Keys in the privileged Q_Key area (MSB set) so
> it's not an issue for applications but I don't understand how you can avoid
> breaking unlucky guest OSes.
>
> Part of my problem is I don't see anywhere that
> MLX4_RESERVED_QKEY_MASK is actually used in this patch...
>

As you probably saw, the isolation mechanism chosen for the 
authentication of the
special QP proxy/tunnel protocol between the VFs and the master is based 
on these
special qkeys. The master ((in mlx4_get_parav_qkey)) makes sure that 
each VF actually
uses a different qkey for its proxy/tunnel qps, and that qkey is forced 
in the QPC,
such that the qkey used by the IB core in the VF is actually ignored on TX.

The reason for using qkeys and not pkeys originates from the limited amount
of pkeys which is supported by the HCA which made it non practical to 
dedicate
a pkey per VF special QP offloading.

So indeed there is a chance for unlucky guest to try and make use of 
qkey from
that range, but when they attempt to plug  that qkey into their QPC, the 
driver
running at the master will fail that out in the code section I pointed 
you to. So
this failure doesn't get unnoticed.


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
