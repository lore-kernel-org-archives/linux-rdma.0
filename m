From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] IB core: Add port_xmit_wait counters
Date: Tue, 12 Jul 2016 07:12:36 -0400
Message-ID: <0dd1b278-2ed9-2c9e-7eab-b28fd985af60@dev.mellanox.co.il>
References: <alpine.DEB.2.20.1607081026550.5092@east.gentwo.org>
 <3bfb4906-4089-1191-8fc9-cebc0f4275ae@dev.mellanox.co.il>
 <alpine.DEB.2.20.1607081442450.8799@east.gentwo.org>
 <1cc963dc-b7d3-f650-d57f-5d5439e6952a@dev.mellanox.co.il>
 <alpine.DEB.2.20.1607101910001.13668@east.gentwo.org>
 <a419cdf4-78b3-20f6-024b-f1233c4febd1@dev.mellanox.co.il>
 <alpine.DEB.2.20.1607111911290.32417@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1607111911290.32417-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/11/2016 8:12 PM, Christoph Lameter wrote:
> On Mon, 11 Jul 2016, Hal Rosenstock wrote:
>>
>> I'm not sure I'm following what you mean. Are you proposing to change
>> _counter to _index ?
>>
> No I am proposing to change the description to refer to index instead.

I see now what you mean:
For the PORT_PMA_ATTR macro the _counter field is set to zero
allowing us to specify the index like with PORT_PMA_ATTR_EXT

The elimination of the unused _counter field from PORT_PMA_ATTR can be
done subsequent to this change.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
