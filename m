From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] IB core: Add port_xmit_wait counter
Date: Fri, 8 Jul 2016 15:51:17 -0400
Message-ID: <1cc963dc-b7d3-f650-d57f-5d5439e6952a@dev.mellanox.co.il>
References: <alpine.DEB.2.20.1607081026550.5092@east.gentwo.org>
 <3bfb4906-4089-1191-8fc9-cebc0f4275ae@dev.mellanox.co.il>
 <alpine.DEB.2.20.1607081442450.8799@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607081442450.8799-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/8/2016 3:43 PM, Christoph Lameter wrote:
> On Fri, 8 Jul 2016, Hal Rosenstock wrote:
> 
>> What does the value of the _counter field have to do with specifying the
>> offset directly ?
> 
> Its used to calculate the offset. See the macro definition.

Isn't it used to calculate the index not the offset (and that part of
index is not used anywhere AFAIT) ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
