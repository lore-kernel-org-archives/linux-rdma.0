From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND for-next 3/7] IB/mlx4: increase the number of vectors
 (EQs) available for ULPs
Date: Thu, 17 May 2012 11:24:18 +0300
Message-ID: <4FB4B5B2.9010400@mellanox.com>
References: <1336494151-31050-1-git-send-email-ogerlitz@mellanox.com> <1336494151-31050-4-git-send-email-ogerlitz@mellanox.com> <CAJZOPZ+53S5q+S2ToiqFQFo6oUP7tpO6gZA4Cu4pBWxrjL-wXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+53S5q+S2ToiqFQFo6oUP7tpO6gZA4Cu4pBWxrjL-wXA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/16/2012 11:42 PM, Or Gerlitz wrote:
> Also, another long pending patch is the one to allow for multiple 
> IPoIB childs @ http://marc.info/?l=linux-rdma&m=132630202116857&w=2 , 
> which will be of use by the eIPoIB - the "Ethernet IPoIB" driver which 
> was presented in the last OFA conference, the patch was initially 
> posted back in November, so far no comment.

Same here, eIPoIB was presented last month in OFA, see the Ethernet 
IPoIB session on that link. The patch I refer to allows to create 
multiple IPoIB interfaces under the same IPoIB parent, where each such 
interface (e.g ib0.1, ib0.2, ... ib0.N) would eventually serve the 
traffic of VM1, VM2, ... VMN

https://openfabrics.org/resources/document-downloads/presentations/cat_view/57-ofa-documents/23-presentations/81-openfabrics-international-workshops/104-2012-ofa-international-workshop/107-2012-ofa-intl-workshop-wednesday.html

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
