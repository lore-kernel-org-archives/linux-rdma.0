From: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: IPoIB GRO
Date: Mon, 04 Nov 2013 10:24:38 +0200
Message-ID: <527759C6.3070009@dev.mellanox.co.il>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173585A3E3B-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Markus,

As Or already mentioned, it seems that we have accumulations of ip 
packets, when GRO is enabled over ib interface, from tcpdump in the 
recieve side we can see:

10:09:27.336951 IP 11.134.33.1.41377 > 11.134.41.1.35957: Flags [.], seq 
3795959253:3796023381, ack 2, win 110, length 64128
10:09:27.336987 IP 11.134.41.1.35957 > 11.134.33.1.41377: Flags [.], ack 
3796023381, win 2036, length 0
10:09:27.337022 IP 11.134.33.1.41377 > 11.134.41.1.35957: Flags [.], seq 
3796023381:3796087509, ack 2, win 110, length 64128
10:09:27.337044 IP 11.134.41.1.35957 > 11.134.33.1.41377: Flags [.], ack 
3796087509, win 3038, length 0
10:09:27.337083 IP 11.134.33.1.41377 > 11.134.41.1.35957: Flags [.], seq 
3796087509:3796151637, ack 2, win 110, length 64128
10:09:27.337107 IP 11.134.41.1.35957 > 11.134.33.1.41377: Flags [.], ack 
3796151637, win 4040, length 0
10:09:27.337142 IP 11.134.33.1.41377 > 11.134.41.1.35957: Flags [.], seq 
3796151637:3796215765, ack 2, win 110, length 64128
.....
....

don't you see that behaviour in tcpdump? what kernel are you using?

I will take a look into the gro/our code to check if we missed 
something, and update.

Thanks, Erez

> Hello,
>
> I have a little update to the unlucky GRO IPoIB behaviour I observed
> in the last weeks in datagram mode on our ConnectX cards. In the
> GRO receive path the kernel steps into the inet_gro_receive() function
> of net/ipv4/af_inet.c. If I read the code right it compares two
> IP packets and decides if they come from the same "flow".
> Further checks are included in some subroutines that narrow
> down the comparison to IPv4 and so on.
>
> I put a debugging message into the following comparison that
> seems to be the culprit of it all.
>
> inet_gro_receive()
>    ...
>    /* All fields must match except length and checksum. */
>    NAPI_GRO_CB(p)->flush |=
>      (iph->ttl ^ iph2->ttl) |
>      (iph->tos ^ iph2->tos) |
>      (__force int)((iph->frag_off ^ iph2->frag_off) & htons(IP_DF)) |
>      ((u16)(ntohs(iph2->id) + NAPI_GRO_CB(p)->count) ^ id);
>    /* Do some debug */
>    printk("%i %i %i\n",ntohs(iph2->id),NAPI_GRO_CB(p)->count,id);
>    ...
>
> On a normal GBit Intel card the kernel output reads:
>
> 32933 12 32945
> 32933 13 32946
> 32946 1 32947
> 32946 2 32948
> ...
> 32946 15 32961
> 32964 3 32967
> 32964 4 32968
> ...
>
> The interpretation of it all should be that packet ids must match
> the sum of the initial packet id plus its count field. Then
> we have a GRO candidate.
>
> On our ib0 interface the count field of a received packet seems
> to be 1 most of the time and the packet id always matches the
> initial packet id:
>
> 35754 1 35754
> 35754 1 35754
> 35754 1 35754
> ...
> 35754 1 35786
> 35786 1 35786
> 35786 1 35786
> ...
>
> Thats why the flush flag is always set and the GRO stack does
> not work at all. I'm willing to dig deeper into this but I'm unsure
> if those fields are filled on sender or receiver side and especially
> where in the IPoIB stack. Maybe someone can point me into the
> right direction so that I can dig deeper and provide some more
> information.
>
> Bet regards.
>
> Markus
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
