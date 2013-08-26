From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3.10.y 0/4] IB/IPoIB fixes for SRIOV / cloud environment
Date: Mon, 26 Aug 2013 14:36:35 +0300
Message-ID: <521B3DC3.3040203@mellanox.com>
References: <1375778322-24408-1-git-send-email-ogerlitz@mellanox.com> <20130806093837.GC27889@kroah.com> <5200DC83.6030903@mellanox.com> <5208BB43.60109@mellanox.com> <20130822214303.GA28717@kroah.com> <CAG4TOxNjptoSkhZZN7xPqZvveBGzR5J3EYZxgdRww_60QjO6bA@mail.gmail.com> <5219BBFC.6010309@mellanox.com> <20130825161936.GA4808@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130825161936.GA4808-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 25/08/2013 19:19, Greg KH wrote:
> On Sun, Aug 25, 2013 at 11:10:36AM +0300, Or Gerlitz wrote:
>> On 23/08/2013 01:36, Roland Dreier wrote:
>>> Sorry for not replying.  My feeling about these patches is basically "meh".
>> English (please)?
> That was English:
> 	http://www.urbandictionary.com/define.php?term=meh

OK, thanks for the pointer, will try harder next time

>
>>> They seem to be correct fixes but I can't convince myself the impact merits applying them to stable.
>> Let it be for now, if it turns out that 3.10.y becomes long term
>> supported (e.g such as 2.6.32, 3.2 etc) I would ask the re-examine this
>> again, we'll see
> That is exactly what 3.10 is going to be:
> 	http://kroah.com/log/blog/2013/08/04/longterm-kernel-3-dot-10/
>
>

OK, good to know, so now when I know what is Meh and understand that 
3.10 is an LTS kernel,
I will revive the discussion at some near future point ...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
