From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Strange NFS client ACK behaviour
Date: Tue, 10 Sep 2013 08:50:46 -0700
Message-ID: <CABgxfbHBSoDmjru7zfG9keKJffSsDabWRimqhSf2VwhwT=v=VQ@mail.gmail.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585722AA@EXCHANGE.collogia.de>
	<CABgxfbF6iWsDei3De0ePsrVnA-a3vYuUbD07Bog6m1Mquy6Ecw@mail.gmail.com>
	<12EF8D94C6F8734FB2FF37B9FBEDD17358574B51@EXCHANGE.collogia.de>
	<CABgxfbHYMi6z-7OHgfQnMNrihHPcqcipCnXZ65q5yXDJzK7rrg@mail.gmail.com>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735857537F@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735857537F-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 9, 2013 at 11:51 PM, Markus Stockhausen
<stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org> wrote:
>> Von: Wendy Cheng [s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Gesendet: Montag, 9. September 2013 22:03
>> An: Markus Stockhausen
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Betreff: Re: Strange NFS client ACK behaviour
>>
>> On Sun, Sep 8, 2013 at 11:24 AM, Markus Stockhausen
>> <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org> wrote:
>>
>> >> > we observed a performance drop in our IPoIB NFS backup
>> >> > infrastructure since we switched to machines with newer
>> >> > kernels.
>> >
>>
>> Not sure how your backup infrastructure works but the symptoms seem to
>> match with this discussion:
>> http://www.spinics.net/lists/linux-nfs/msg38980.html
>>
>> If you know how to recompile nfs kmod, Trond's patch does worth a try.
>> Or open an Ubuntu support ticket, let them build you a test kmod.
>>
>> -- Wendy
>
> Thanks for pointing into that direction. From my understanding this
> patch goes into the NFS client side. I built a patched module for my
> Fedora 19 client (3.10 kernel). Nevertheless the behaviour ist still
> the same.  If I get the patch right it is about forked childs that
> access a page of a mmapped file round robin and the kernel issues
> tons of write requests to the file.
>
> My case is only about ACK transmissions for a single writer.
>
> Markus
>

So you have to go back to the drawing board :(. Have you tried to profile it ?
http://oprofile.sourceforge.net/about/

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
