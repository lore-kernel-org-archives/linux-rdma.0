From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH fixes/for-3.6 2/3] IB/ipoib: Fix AB-BA deadlock when deleting
 neighbours
Date: Thu, 13 Sep 2012 08:30:05 +0300
Message-ID: <50516F5D.1070205@mellanox.com>
References: <1346253275-12347-1-git-send-email-ogerlitz@mellanox.com> <1346253275-12347-3-git-send-email-ogerlitz@mellanox.com> <CAL1RGDUGuEE-5X10j6Y0B8fkSH1a1=NDARFYumwwmSjtE0WsJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUGuEE-5X10j6Y0B8fkSH1a1=NDARFYumwwmSjtE0WsJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/09/2012 19:23, Roland Dreier wrote:
> thanks, applied this and 1/3

OK, what about 3/3, any issue with merging it? also, I don't see them 
applied in your kernnel.org
tree fixes branch nor for-next, are you going to push them to 3.6 soon?


>
> On Wed, Aug 29, 2012 at 8:14 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>                  while ((neigh = rcu_dereference_protected(*np,
>> -                                                         lockdep_is_held(&ntbl->rwlock))) != NULL) {
>> +                                      lockdep_is_held(&priv->lock))) != NULL) {
> please try to avoid messing up indentation when doing fixes like this.

will take care to do so
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
