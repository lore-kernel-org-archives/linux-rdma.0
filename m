From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs V3 3/3] Add ibv_query_port_ex support
Date: Tue, 13 May 2014 09:18:01 -0400 (EDT)
Message-ID: <594.223259440874$1399987140@news.gmane.org>
References: <1399531883-30599-1-git-send-email-ogerlitz@mellanox.com> <1399531883-30599-4-git-send-email-ogerlitz@mellanox.com> <20140508190951.GB25849@obsidianresearch.com> <5370BCF2.7050107@mellanox.com> <20140512164323.GA20666@obsidianresearch.com> <CAL1RGDXYwPHrS7dSWg0ojyiPG7TF1Y0800q801kWvMxoyn3c8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXYwPHrS7dSWg0ojyiPG7TF1Y0800q801kWvMxoyn3c8g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----- Original Message -----
> > BTW, before I forget, the patch that introduces the API must also
> > include a man page for it.
> 
> Jason, care to send a patch for the README or whatever with the
> rules? :)

README.Extensions_API_and_Guidelines ?  I wouldn't bury it in the
generic README, people won't know to look there when working
specifically on an extension.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
