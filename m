From: Bernd Schubert <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org>
Subject: Re: srp sg_tablesize
Date: Sat, 21 Aug 2010 20:20:54 +0200
Message-ID: <201008212020.55028.bs_lists@aakef.fastmail.fm>
References: <201008200949.54595.bs_lists@aakef.fastmail.fm> <1282408043.20840.13.camel@obelisk.thedillows.org> <AANLkTimFS=QkHd9+393mS1gQ5ZnL79jSDQaUZ8C_Xd2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimFS=QkHd9+393mS1gQ5ZnL79jSDQaUZ8C_Xd2A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bernd Schubert <bschubert-LfVdkaOWEx8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Saturday, August 21, 2010, Bart Van Assche wrote:
> On Sat, Aug 21, 2010 at 6:27 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> > On Sat, 2010-08-21 at 13:14 +0200, Bart Van Assche wrote:
> > > On Fri, Aug 20, 2010 at 9:49 AM, Bernd Schubert
> > > 
> > > <bs_lists-ivAEE9vf7JuUmYeGgvxl9AC/G2K4zDHf@public.gmane.org> wrote:
> > > > In ib_srp.c sg_tablesize is defined as 255. With that value we see
> > > > lots of IO requests of size 1020. As I already wrote on linux-scsi,
> > > > that is really sub- optimal for DDN storage, as lots of IO requests
> > > > of size 1020 come up.
> > > > 
> > > > Now the question is if we can safely increase it. Is there somewhere
> > > > a definition what is the real hardware supported size? And shouldn't
> > > > we increase sg_tablesize, but also set the .dma_boundary value?
> > > 
> > > (resending as plain text)
> > > 
> > > The request size of 1020 indicates that there are less than 60 data
> > > buffer descriptors in the SRP_CMD request. So you are probably hitting
> > > another limit than srp_sg_tablesize.
> > 
> > 4 KB * 255 descriptors = 1020 KB
> > 
> > IIRC, we verified that we were seeing 255 entries in the S/G list with a
> > few printk()s, but it has been a few years.
> > 
> > I'm not sure how you came up with 60 descriptors -- could you elaborate
> > please?
> 
> The original message mentions "size 1020" but not the unit of that
> size. So I guessed that this referred to an SRP_CMD information unit
> of 1020 bytes. And in a SRP_CMD message of 1020 bytes there fit at
> most 59 descriptors ((1020-68)/16). Now that I see your computation,
> I'm afraid that my guess about the meaning of the original message was
> wrong. Looks like I have been delving too deep into the SRP protocol

Er sorry, I really meant 1020K IOs. That is something that easily can be 
monitored on DDN storage.


> > ...
> 
> > > Did this occur with buffered (asynchronous) or unbuffered (direct) I/O
> > > ? And in the first case, which I/O scheduler did you use ?
> > 
> > I'm sure Bernd will speak for his situation, but we've seen it with both
> > buffered and unbuffered, with the deadline and noop schedulers (mostly
> > on vendor 2.6.18 kernels). CFQ never gave us larger than 512 KB
> > requests. Our main use is Lustre, which does unbuffered IO from the
> > kernel.
> 
> If ib_srp is already sending SRP commands with 255 descriptors,
> changing the configuration of the I/O scheduler or the I/O mode will
> not help.
> 
> What might help - depending on how the target is implemented - is
> using an I/O depth larger than one. ib_srp sends all SRP_CMDs with the

It depends if we enable write-back cache or not. The older S2A architechture 
does not mirror the cache at all and therefore write-back cache is supposed to 
be disabled. The recent SFA architechture mirrors the write-back cache and so 
it supposed to be enabled. With enabled witeback-cache an 'improved' command 
processing is done (I don't know details myself). However, cache mirroring is 
an expensive operation if the system can do 10GB/s and there IOs only will go 
into the cache, if the size is not a multiple of 1024K. 1MiB IOs are directly 
send to the disks. And now that leaves us with srp, where we see to many 1020K 
request, which will need to be processed by the write-back cache....


> task attribute SIMPLE, so a target is allowed to process these
> requests concurrently. For the ib_srpt target I see the following
> results over a single QDR link and a NULLIO target (fio
> --bs=$((1020*1024)) --ioengine=psync --buffered=0 --rw=read --thread
> --numjobs=${threads} --group_reporting --gtod_reduce=1 --name=${dev}
> --filename=${dev}):
> 
> I/O depth Bandwidth (MB/s)
>     1       1270
>     2       2300
>     4       2500
>     8       2670
>    16       2700
> 
> That last result is close to the bandwidth reported by ib_rdma_bw.


How exactly do you do that? Is that something I would try with our storage as 
well? I guess only with a special firmware version, which I also do not have 
access to.

Thanks,
Bernd


-- 
Bernd Schubert
DataDirect Networks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
