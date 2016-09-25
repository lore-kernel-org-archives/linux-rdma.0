From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] libocrdma: Move ocrdma's list
 implementation into common directory
Date: Sun, 25 Sep 2016 10:50:51 -0700
Message-ID: <6776b1b6-e337-f4cb-c7db-1d3c41471884@sandisk.com>
References: <1474786207-2149-1-git-send-email-leon@kernel.org>
 <1474786207-2149-5-git-send-email-leon@kernel.org>
 <20160925144121.GA12246@infradead.org> <20160925161315.GD4088@leon.nu>
 <20160925162203.GA32434@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925162203.GA32434-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/25/16 09:22, Christoph Hellwig wrote:
> On Sun, Sep 25, 2016 at 07:13:15PM +0300, Leon Romanovsky wrote:
>> Any suggestion where can we get list.h compliant with BSD license?
>> Is this enough [1] ?
>
> That one looks like someone who knew the Linux one very well spend
> a lot of effort obsfucating it after starting with the Linux version :)
>
> If I were the copyright holder of the file I'd be okay with that given
> that the list implementation is pretty much trivial anyway.
>
> But given that I don't know who owns every little bit of the Linux
> lists.h I'd simply avoid anything looking like it and use something
> like the BSD queue.h instead (which glibc also provides, but in a
> horribly outdated version).

How about using <list> from libstdc++? It is allowed to use libstdc++ 
headers to build non-GPL software. See also 
https://gcc.gnu.org/onlinedocs/libstdc++/manual/license.html for 
libstdc++ license information.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
