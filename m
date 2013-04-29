From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband use of get_user_pages()
Date: Mon, 29 Apr 2013 11:44:19 -0700
Message-ID: <CAL1RGDWPujGT6HKDg74dFT=C64NyO7y1aYjM1LH9YHZcWbf7qA@mail.gmail.com>
References: <20130424153810.GA25958@quack.suse.cz> <CAL1RGDXqtLPmM0kRofFwTv+jzr2cBGoe9X7oQLO_yoHGErJnxg@mail.gmail.com>
 <20130425132157.GA32353@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130425132157.GA32353-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 25, 2013 at 6:21 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
>> get_user_pages() actually goes to some trouble to return all small pages,
>> even when it has to split a single huge page into many entries in the
>> page array.  (Which is actually a bit unfortunate for our use here)

>   Does it? As far as I'm checking get_user_pages() and the fault path I
> don't see where it would be happening...

I'm talking about where __get_user_pages() calls follow_hugetlb_page()
and loops to fill in many entries in the page array from one huge
page.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
