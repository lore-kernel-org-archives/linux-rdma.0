From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs] memory: use SCNxPTR format to read uintptr_t
 values
Date: Wed, 11 Jul 2012 10:09:21 -0600
Message-ID: <20120711160921.GA28982@obsidianresearch.com>
References: <1342019435-10041-1-git-send-email-ydroneaud@opteya.com>
 <CAL1RGDUQiWdSYbCH8k7Bwu8y549wQtQ7=tPA1G=uJuGW76G4hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDUQiWdSYbCH8k7Bwu8y549wQtQ7=tPA1G=uJuGW76G4hA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 11, 2012 at 08:47:05AM -0700, Roland Dreier wrote:

> Looks fine in itself, and I don't necessarily expect you to be the one
> to answer, but:
> 
>  - what does /proc/<pid>/maps show when running a 32-bit process on a 64-bit
>    kernel?  Should we be using uint64_t / SCNx64?  (but surely 32-bit processes
>    are guaranteed to have all their mappings fit into 32 bits)

Linux 2.6.35.9 #3 Wed Jan 5 12:06:51 MST 2011 x86_64 GNU/Linux

08048000-08052000 r-xp 00000000 ca:00 32652                              /bin/cat

So PTR seems right..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
