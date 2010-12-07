From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: IPoIB to Ethernet routing performance
Date: Tue, 7 Dec 2010 12:02:32 +0200
Message-ID: <4CFE0638.2040105@voltaire.com>
References: <20101206112454.76bb85f1@frecb012350.frec.bull.fr>	<4CFD4BEE.5070205@shiftmail.org>	<20101206212759.GB16788@obsidianresearch.com> <20101207083911.2ab47a59@frecb012350.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101207083911.2ab47a59-xRPE6/W2vR9iM9LT7/dT9zWMkbuR3peG@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sebastien dugue <sebastien.dugue-6ktuUTfB/bM@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

sebastien dugue wrote:
>   What kind of offload capabilities are you referring to for IPoIB?
>
TCP stateless offloads: checksum, LSO, LRO (to be replaced to GRO, 
sometime, sooner the better)

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
