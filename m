From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-3.11 7/7] IB/iser: Introduce fast memory registration
 model (FRWR)
Date: Mon, 22 Jul 2013 17:37:59 +0300
Message-ID: <CAJZOPZL+8XdMRtkmfFUy00udxkz5nUhhLHu8VXLq8x9dnONjZA@mail.gmail.com>
References: <1374153931-7313-1-git-send-email-ogerlitz@mellanox.com>
	<1374153931-7313-8-git-send-email-ogerlitz@mellanox.com>
	<51ED1B8E.7070703@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51ED1B8E.7070703-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 22, 2013 at 2:46 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
[...]
> What will happen if a new FRWR is submitted with an rkey that is still valid ?

The HW will fail this WR, we must invalidate the mapping before re-using the MR.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
