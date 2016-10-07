From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5 for rdma-core] Five rxe_cfg patches
Date: Sat, 8 Oct 2016 03:44:03 +0530
Message-ID: <CAG53R5VeHut-Sj-4nX07TQEqUnxKxCangnpj5jwd36=4sHwJrA@mail.gmail.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <20161007190224.GB27537@obsidianresearch.com> <c1901fd9-3620-50ec-0db3-9b271fd1e90b@sandisk.com>
 <20161007210038.GA9810@obsidianresearch.com> <CAG53R5XMwgs6rj9cMnniHk8xvYqk9zxOv1Nuhog3CJfNCpmDFg@mail.gmail.com>
 <20161007220736.GB9810@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161007220736.GB9810-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 8, 2016 at 3:37 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Sat, Oct 08, 2016 at 03:12:45AM +0530, Parav Pandit wrote:
>
>> Instead of relying on user land to do configuration of different OS
>> flavors, I am considering to auto create rxe interfaces via netdev
>> notifier for all the network interfaces which gets newly added.
>
> Interesting, my concern is that rxe seems to currently be buggy and
> inadvertently enabling rxe on any non-dev systems at this time is
> probably insane from a security perspective :\
>

Sure. Yes. I agree. Once its stable I can take this up.
However if rdma_rxe is not loaded, its should be fine.

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
