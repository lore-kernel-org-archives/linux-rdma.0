From: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG) meeting tomorrow
 - 5/3/2016
Date: Mon, 2 May 2016 17:51:19 +0000
Message-ID: <HE1PR05MB1418D253A2B5F7DEAD633C73B1790@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org'" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

We will continue the uAPI discussions tomorrow.
See meeting notes of last meeting and contact details below.
--Liran

Notes (4/19/2016):

Nested attributes, similar to netlink, seem to offer a useful, extensible way to pass parameters. However, netlink sockets are not suitable for simple synchronous system calls.
A new system call doesn't seem to be the right approach. Rather, ioctls should be used as the basis for the uAPI.
DRM could be used as a reference of a ioctl-based uAPI.

It was suggested that uAPI calls could go directly into drivers, which can then call shared code in the kernel.
This could be a good flow for provider-specific flows. However, for common objects, the mapping from uAPI to kAPI objects is a good thing, as the kernel can reason about dependencies and semantics.

It was questioned whether a more involved parameter parsing scheme would hurt performance. For control operations such as object creation and manipulation, is seems that the majority of the overhead is in provider code/device anyway.
For data path operations, either user-space accesses HW directly, or providers can use the direct provider channel for optimal operations. The current postsend() uAPI calls could be removed in favor of optimized provider calls.
 
ucm should be considered as a candidate for deprecation, optionally by supporting only the old uAPI.
In any case, we need a backward compatible option for all interfaces.

mmap can be kept for backward compatibility.
Alternatively, providers may use a new FD for this.

Device-specific cdevs could be retained, but this might be rejected by the kernel community. The wireless cdevs, for example, were unified.
A single entry point has advantages in terms of udev rules, namespaces, access control, etc.
A provider channel could be supported by multiplexing the uverbs FD or by spawning an anon FD, with a tendency towards the latter.

> 
> Following the discussions at OFA'16 workshop between RDMA users, providers,
> and the maintainer, it was suggested to make more extensive use of the Open
> Fabrics Verbs Working Group (OVFWG) venue to hold interactive discussions on
> mutual issues and facilitate reaching agreement.
> 
> The OFVWG discussions are open to anyone.
> Feel free to join the mailing list at:
>         http://lists.openfabrics.org/mailman/listinfo/ofvwg
> (Meeting schedules, summary notes, and main discussion points will also be sent
> to linux-rdma.)
> 
> Meetings are held over Lync at:
>         https://mtlmeet.mellanox.com/shainer/W24KL6ZS
> 
> The meetings are generally held on Tuesdays at 11:00PDT, on a per-topic basis.
> Meeting invites are sent to the mailing list as these arise.
> 
> This week (tomorrow), the agenda is to discuss the wish-list for improving the
> ABI of several components of the RDMA stack.

> Join by phone:
> 
> +972 (74) 7237000 (Israel) (Mellanox) 		English (United States)
> +86 10800 7122375 (China Toll Free) (Mellanox) 		Chinese (Simplified,
> PRC)
> +33 (805) 107910 (France Toll Free) (Mellanox) 		English (United States)
> +49 (800) 5892698 (Germany Toll Free) (Mellanox) 		English
> (United States)
> 8 800 1006947 (Russia Toll Free) (Mellanox) 		English (United States)
> +44 (800) 1700936 (UK Toll Free) (Mellanox) 		English (United States)
> +886 (00) 80 1856740 (Taiwan Toll Free) (Mellanox) 		English
> (United States)
> +1 (888) 3314421 (US Toll Free) (Mellanox) 		English (United States)
> +972 (1809) 494180 (IL Toll Free) (Mellanox) 		English (United States)
> +40 (800) 895907 (Romania Toll Free) (Mellanox) 		English
> (United States)
> +61 (1800) 055101 (Australia Toll Free) (Mellanox) 		English
> (United States)
> +81 (800) 1700770 (Japan Toll Free) (Mellanox) 		English (United States)
> +82 (007) 9885214386 (South Korea Toll Free) (Mellanox)
> 	English (United States)
> +4 580 880 552 (Denmark Toll free) (Mellanox) 		English (United States)
> +44 (203) 1500253 (UK) (Mellanox) 		English (United States)
> +1 (408) 9160061 (US West) (Mellanox) 		English (United States)
> +1 (978) 4395425 (US East) (Mellanox) 		English (United States)
> +91 000 (800) 1004157 (India Toll Free) (Mellanox) 		English
> (United States)
> +55 (800) 8917640 (Brazil Toll Free) (Mellanox) 		Portuguese (Brazil)
> +52 (1800) 7334070 (Mexico Toll Free) (Mellanox) 		English
> (United States)
> Find a local number
> 
> Conference ID: 5777016
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
