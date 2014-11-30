From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/2] Adding support for RoCE V2 specification
Date: Sun, 30 Nov 2014 08:32:46 +0200
Message-ID: <CAG9sBKOW+mgomkFYNbkby5eMYGArDzxrh1HUyFY4wMB1zxe2pg@mail.gmail.com>
References: <51dd1341-8216-494f-9574-120634cad8e7@CMEXHTCAS1.ad.emulex.com>
	<CAG9sBKPGbHc49rLx+z3N+bgzMakFks2ihvgAkZpmjUz==2ZYDQ@mail.gmail.com>
	<7F44EA5110810A40B7DAFB605C41975D312F40F4@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7F44EA5110810A40B7DAFB605C41975D312F40F4-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <Somnath.Kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Yes, that is correct.
>
> The overarching goal behind this patch is to keep RDMA-CM as the central entity that decides the protocol (ROCEV2 /ROCEV1)
> and hides all the address resolution details from applications.
I agree but with one comment. RDMA-CM, although preferred,  is not
mandatory to establish a connection. The solution needs to take care
also for
apps that don't use RDMA-CM

> This  is just a continuation of the existing RDMA-CM design philosophy for IP Based GIDs that lets applications operate over any form
> of RDMA Service in a completely transparent way without any changes to the applications themselves.
>
> Protocol Resolution(RoCEV2 or V1) must be done even before we
> send out the 1st connection request packet, the corresponding MAD pkt must be V2 for a destination that is behind  a router, correct?
> I am not sure we want to try sending out RoCEv2 connection requests first and if that fails ,then fallback/retry with RoCEv1 request.
I agree but when you send the first packet (request or response) you
know the SGID index to be used. Knowing that and assuming you chose
the SGID index correctly there is no need to guess.
A suggestion for choosing the SGID index is:
1. First, populate GID table with GIDs matching the IP address list of
the corresponding net devices. Each GID will appear twice, one for
RoCEv1 and one for RoCEv2.
2. When connection is being established RDMA-CM will choose one of the
2 matching indices based on a
preferred protocol attribute for the rmda_id (new attr.)
3. Proffered protocol is
     a) global for the node/fabric based on the administrator settings
     b) can be changed by applications that want to override the
default (requires extra API)


> That would needlessly complicate and slow down the connection-establishment process, do you agree ?
> Instead it's much more seamless to take help of the IP stack to select the network header type and subsequently the ROCE pkt format while
> attempting to establish the connection.
>
> The one thing that my patch does miss out though is the ability for local subnet end nodes to be able to communicate using RoCEv2 packet formats.
> (The default policy in this patch is to use ROCEV1 for nodes connected directly /within the same local subnet.)
> I believe that can be achieved by extending RDMA-CM to override the default protocol selection policy proposed in this patch by making use of
> the GID Entry attribute type in another patch.
Right, and this seems to fit the proposal above.


> This scheme should still work with your proposal  in point# 2 , where GID Table management would move to a central/stack module instead of being
> vendor specific.
>
> Thanks
> Som
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
