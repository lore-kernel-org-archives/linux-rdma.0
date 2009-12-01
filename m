From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC] opensm: compress IPV6 SNM groups to use a single
 MLID
Date: Tue, 1 Dec 2009 16:58:47 +0200
Message-ID: <20091201145847.GM16607@me>
References: <20091113061948.GJ7192@me>
 <20091113062104.GK7192@me>
 <20091113201144.GS7192@me>
 <20091113203856.GT7192@me>
 <20091113204041.GU7192@me>
 <f0e08f230911160735i69ad3671m9a2667900b933e13@mail.gmail.com>
 <20091126163634.GJ13817@me>
 <f0e08f230911301148t8d573c7lf1f67972b5438b72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f0e08f230911301148t8d573c7lf1f67972b5438b72-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:48 Mon 30 Nov     , Hal Rosenstock wrote:
> 
> The multicast tree (MLID) has one rate, MTU, etc. so these parameters
> should be enforced on multicast groups (MGIDs) overlaid on the same
> MLID.

Assuming that Multicast groups (MGIDs) are consistent in terms of rate,
MTU and packet life time parameters. Why should we share this over MLID
implementing MGID to MLID compression?

Sharing P_Key helps to prevent P_Key violation traps, but what should be
a reason for rate, MTU and packet life time?

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
