From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Wed, 3 Jun 2015 19:55:58 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1506031953500.11879@east.gentwo.org>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com> <1433098827.114391.179.camel@redhat.com> <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com> <1433157904.114391.188.camel@redhat.com> <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com> <20150602180844.GD17776@obsidianresearch.com> <CAJ3xEMjZqwJC8=HrMBv_eSVKVtLW7qjVZNjtuD28octGPtYu6w@mail.gmail.com> <20150603204633.GE7902@obsidianresearch.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150603204633.GE7902-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 3 Jun 2015, Jason Gunthorpe wrote:

> MHz is fine *for mlx hardware* but someone elses hardware that uses,
> say 312.5 MHz (ie the ethernet symbol clock) is NOT OK because MHz
> looses too much precision.

Oscillator vary in frequency. In order to accurately convert to NS the
drift due to temperature etc needs to be taken into consideration. The
"ns" value there is pretty rough as well. Accurate time may need time
software to continually monitor the *actual* frequency of the oscillator.
I thknk the raw cycles and the rought oscillator speed are fine.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
