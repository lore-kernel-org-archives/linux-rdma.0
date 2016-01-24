From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Sat, 23 Jan 2016 19:13:49 -0800
Message-ID: <CA+55aFxHrSB4cqs6Pzk3-AwJB17F2sTyunNGBjiCL0=Uijr-gg@mail.gmail.com>
References: <56A2727B.8040809@redhat.com>
	<CA+55aFziXhmMRk3HqvrUtVv+SaUM0zu3=LKbxo0w9HZPVmDuyw@mail.gmail.com>
	<56A30910.9010002@redhat.com>
	<CA+55aFzhwDNiBr0MKyFYn8WCLxhPrBxU0TPTSskm5B3VkzhD9g@mail.gmail.com>
	<56A3A777.3@redhat.com>
	<CA+55aFzeW-UjwWarz9hZ3dgnTFSJuNFJ2_YikJPbXAZ_i2+RSw@mail.gmail.com>
	<56A3FE6F.4000800@redhat.com>
	<CA+55aFz9Dnu7Ri8XA291VdSYZ5gqyt+cmaaRNULQ0hVetoAJZg@mail.gmail.com>
	<56A42829.90401@redhat.com>
	<CA+55aFy0OuZ+TOsNRkqyGbpJf1LvLAodO2DqUfpcrKsQHQWLxw@mail.gmail.com>
	<CA+55aFymjONiSk+gVRk8XaViw9BuG1A6KgGWHgq=kj+XZsEw8w@mail.gmail.com>
	<CA+55aFzh4_T6MUM7CQsBc5AVe5WhiG=SDkXpRH_eNOZKPMAZMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzh4_T6MUM7CQsBc5AVe5WhiG=SDkXpRH_eNOZKPMAZMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 23, 2016 at 7:05 PM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
>
> rdma had better not be this kind of pain in the arse in the future,
> because I really will just stop pulling if it is.

Side note: I'd suggest you start using branches for rdma. Because I'm
going to be very picky about my rdma pulls going forward, and if  you
put everything in one big pile, the likelihood that it just gets
rejected is now very very high.

Using separate branches means that I can decide to merge the sane and
easy stuff. The stuff that doesn't contain Mellanox shit, in other
words. The stuff that isn't controversial.

At least that way you get *something* merged. Because right now I'm
actually so fed up with this that if I hadn't already pushed it out, I
would have decided to just undo the pull after all.

                    Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
