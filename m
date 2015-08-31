From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mlx4 problems with 4.2-rc8
Date: Mon, 31 Aug 2015 23:21:02 +0300
Message-ID: <CAJ3xEMjp+3Y0y2d-K-zi9SnBSshN_C5x5KLY3oCpD_XriDCsWw@mail.gmail.com>
References: <55E142DC.8060205@redhat.com>
	<CAJ3xEMj5By11L3qbSKxcEiMarB6CeyeERMnuK_vvH11VLLFypw@mail.gmail.com>
	<55E385DB.2@redhat.com>
	<55E3FDAB.10706@mellanox.com>
	<55E45058.1070105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E45058.1070105-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 31, 2015 at 4:02 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 08/31/2015 03:09 AM, Matan Barak wrote:

>> Actually, it looks like the dump stack we've got before [1] was fixed.
>> This happens when the mlx4 driver is used in setups where number of
>> cores >= 32.

>> Doug, is that the case?

> Indeed, 48 cores on this machine.

so do we have bingo here? the patch is in the net-next tree (and we
can't put it in 4.2 only through -stable since 4.2 is released by
now), does it solves the problem?

Or.

>> [1] http://www.spinics.net/lists/netdev/msg341171.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
