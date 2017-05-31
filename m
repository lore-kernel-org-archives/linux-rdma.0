From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: How do I generate and set a GUID on an Ethernet VF with ConnectX-4?
Date: Wed, 31 May 2017 10:02:23 -0600
Message-ID: <CAANLjFqQkhdB0LAzEsDr33x09omrQfWXv_x-LgSwdktcv4mmuA@mail.gmail.com>
References: <CAANLjFoHJhCJpZ+9uogHE4nSLkrdTRbGgS4mO5un_M+mNYdmCw@mail.gmail.com>
 <847B5D33-D362-40F1-82B6-DB2F7B2BA1AA@mellanox.com> <CAANLjFpMXrO-QXiOmnCz=kKgf1mrsHRR_Xy6eido97gmU80SZQ@mail.gmail.com>
 <EAE997AA-1144-49D6-824B-E981F12EEF2B@mellanox.com> <CAANLjFqTRd1sk75jhUXEV892wK2yLPytA0DDQzhWirzJAFCN6Q@mail.gmail.com>
 <B9E3401C-856E-46D2-B0B1-8B0371F6881D@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B9E3401C-856E-46D2-B0B1-8B0371F6881D-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 31, 2017 at 9:50 AM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Is this the same issue you were facing with rdma-cm segfaults?

The '0' GUID was causing a segfault in rping, udaddy, ib_send_bw in
rdma_cm mode, etc. When both nodes have a GUID, it works fine. It
could be argued that it should be a bit more helpful and exit with a
nice message rather than a segfault. It also could be argued that a
random GUID/MAC should be assigned at VF creation time and if you want
something static to go through the hoops (it sounds like a good
default so it works out of the box, I even though I thought I read
that was the behavior but I can't find that document again). I can
work around it by adding the random generation to my udev rules, but
it is not convenient. I think I'll have to check if a MAC is already
assigned or I could get into a loop, I'll have to look at it more
later. I need to get source address binding working in iSER first.

Thanks again,

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
