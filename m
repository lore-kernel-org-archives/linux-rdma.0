From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Expose ioctl command to retrieve SGID of a
 given socket
Date: Wed, 6 Jan 2016 14:25:52 +0200
Message-ID: <568D07D0.8080404@mellanox.com>
References: <1451572875-24961-1-git-send-email-yuval.shaia@oracle.com>
 <56854AEB.50802@mellanox.com> <20160106110344.GB5070@yuval-ThinkPad-X220>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106110344.GB5070@yuval-ThinkPad-X220>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/01/2016 13:03, Yuval Shaia wrote:
> On Thu, Dec 31, 2015 at 05:34:03PM +0200, Haggai Eran wrote:
>>> +	sock = sockfd_lookup(fd, &rc);
>>> +	if (IS_ERR_OR_NULL(sock))
>>> +		return -EINVAL;
>>> +
>>> +	inetsock = inet_sk(sock->sk);
>>> +
>>> +	neigh = neigh_lookup(&arp_tbl, &inetsock->inet_daddr, dev);
>>
>> Also, isn't inet_daddr the destination address? But the function claims 
>> to return the SGID. I guess these can be ambiguous but still it seems 
>> confusing.
> Per description in include/net/inet_sock.h looks like that inet_daddr is
> the address of source peer of the socket.
> * @inet_daddr - Foreign IPv4 addr
>>

I meant it was confusing to have the foreign address in the socket designated 
by "daddr" while the function you proposed returned the foreign GID as SGID.

Haggai

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
