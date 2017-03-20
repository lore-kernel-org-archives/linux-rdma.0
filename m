From: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Subject: Re: no QFSP detection with HFI card
Date: Mon, 20 Mar 2017 12:17:42 +0100
Message-ID: <20170320121742.6f1727544fde566c5503caab@suse.de>
References: <20170313125116.4cab1f75ba4d0dd0fe96e0df@suse.de>
        <ded534e0-47a9-001d-3006-3ac6667ab446@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ded534e0-47a9-001d-3006-3ac6667ab446-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 17 Mar 2017 09:25:56 -0400
Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> On 03/13/2017 07:51 AM, Thomas Bogendoerfer wrote:
> > Hi,
> >
> > I'm tyring to connect a HFI card to an Omni-Path Edge Switch 100. The
> > switch detects the QSFP just fine:
> >
> > Cable05  OEM         Copper     3 meter   20.87  ???  MCP1600-E003-C    6   M9AL0003          Valid
> >
> > But on the host side, I only get:
> >
> > [   53.060613] hfi1 0000:01:00.0: hfi1_0: wait_for_qsfp_init: No IntN detected, reset complete
> > [   53.082820] hfi1 0000:01:00.0: hfi1_0: i2c_bus_write: bus 1, i2c slave 0x50, offset 0x7f, len 0x1; write failed, ret -6
> > [   53.114661] hfi1 0000:01:00.0: hfi1_0: port 1: QSFP chain 1 can't write QSFP_PAGE_SELECT_BYTE: -6
> > [   53.137353] hfi1 0000:01:00.0: hfi1_0: QSFP not responding, waiting and retrying 0
> >
> > Any hint why the card doesn't find the plugged in QSFPs ?
> 
> Please refer to the Intel Omni Path cable support matrix for a list of 
> supported cables: 
> http://www.intel.com/content/www/us/en/high-performance-computing-fabrics/omni-path-cables.html. 
> 
> If you need help with cables not on this list, please contact the cable 
> manufacturer or supplier for assistance.

so why does the _INTEL_ switch accept the cable while the _INTEL_ HFI card doesn't ?

And the I2C interface to the QSFPs looks like bitbang on GPIO lines so even
if there the quality of the cable isn't good enough, I would have expected to see
at least the QSFP register via I2C (I tried via i2c-cdev/i2c-detect, but there
is simply nothing). Anyway thank you for your help.

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
