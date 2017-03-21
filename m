From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Need some pointers to debug a KASAN splat in NVMe over Fabrics
 with rdma-rxe
Date: Tue, 21 Mar 2017 09:12:56 -0400
Message-ID: <20170321131255.GA24294@linux-x5ow.site>
References: <5b16edcf-c39a-bc4b-0e32-8ccfb5d75efb@suse.de>
 <CAG9sBKPwEryc7U+hV=XJvRrFFhNvoktDOtwwS6piUw=cQ=bZhA@mail.gmail.com>
 <38a12b22-7bad-c069-4c96-39fc93d20d79@suse.de>
 <CAG9sBKNXwHFkmQYsOPPu40822h6Z7J3+63CaZ844juZp5hfHfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKNXwHFkmQYsOPPu40822h6Z7J3+63CaZ844juZp5hfHfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux NVMe Mailinglist <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 09, 2017 at 12:59:31PM +0200, Moni Shoua wrote:
> >> 2. You can take a look at librxe implementation of init_send_wqe() (it
> >> looks slightly different from kernel's implementation) and see what
> >> happens if you change implementation accordingly.
> >
> > OK I'll have a look and hopefully come back with a (RFC) patch (fingers
> > crossed).
> 
> Thanks. Waiting to see what you found and in the meantime I'll try to
> reproduce in my setup

Hi Moni,

I got the NVMf with RXE connection problems (minus the KASAN splats)
traced down to the check_rkey() function. It bailes out on this code
in check_rkey():

       if (pkt->mask & RXE_WRITE_MASK)  {
                if (resid > mtu) {
                        if (pktlen != mtu || bth_pad(pkt)) {
                                state = RESPST_ERR_LENGTH;
                                goto err;
                        }

			qp->resp.resid = mtu;
                } else {
                        if (pktlen != resid) {


This even happens if I set the mtu to 9000.

I instrumented the driver to get some more debug information out of it and
here's the last output I see before nvme enters an error state and reconnects:

rdma_rxe: write_data_in: data_len: 4096, qp->resp.resid: 4096
rdma_rxe: check_rkey: mtu: 4096, resid: 12288, pktlen: 4096
rdma_rxe: write_data_in: data_len: 4096, qp->resp.resid: 4096
rdma_rxe: check_rkey: mtu: 4096, resid: 0, pktlen: 4096
rdma_rxe: qp#19 moved to error state
nvme nvme0: RECV for CQE 0xffff88001f0ef240 failed with status WR flushed (5)

qp->resp.resid comes from this hunk in check_rkey():
       if (pkt->mask & (RXE_READ_MASK | RXE_WRITE_MASK)) {
                if (pkt->mask & RXE_RETH_MASK) {
                        qp->resp.va = reth_va(pkt);
                        qp->resp.rkey = reth_rkey(pkt);
                        qp->resp.resid = reth_len(pkt);

So I suppose reth_len() has some hiccups here. I'll continue debugging and
report back any new findings.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
