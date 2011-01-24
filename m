From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Mon, 24 Jan 2011 13:00:37 -0500
Message-ID: <1295892037.29946.10.camel@lap75545.ornl.gov>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
 <aday66hxxwe.fsf@cisco.com> <4D3805C4.6010203@voltaire.com>
 <1295528044.22825.64.camel@obelisk.thedillows.org>
 <4D3D9B74.8090607@voltaire.com>
 <AANLkTikapxELx5B6knAm6CQaeLsKHWd9EMQeexmFdF1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <AANLkTikapxELx5B6knAm6CQaeLsKHWd9EMQeexmFdF1Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2011-01-24 at 11:14 -0500, Bart Van Assche wrote:
> On Mon, Jan 24, 2011 at 4:32 PM, Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
> > David Dillow wrote:
> >>> if we look on the 50% for SAS/1M IOs that you're presenting, can you tell
> >>> what made the difference, srp went from sg_tablesize of 255 to 256 so the
> >>> upper layers where able to provide 1M as one IO
> >
> >> This win is from sg_tablesize going from 255 to 256 in this case; the HW
> >> really likes that better than getting two requests -- one for 1020 KB
> >> and one for 4 KB.
> >
> > Its always nice to find the simplest explanation to the greatest
> improvement... going to the 2nd largest gains
> >
> >> SAS   2M      520 MB/s        861 MB/s
> >> SAS   4M      529 MB/s        921 MB/s
> >> SAS   8M      600 MB/s        951 MB/s
> >
> > I wonder what made the difference here? it can't be only the 255 -->
> > 256 sg_tablesize change, for the 2M case
> > the change to use 512 pages FMRs could let you use one rkey/fmr for
> > the whole IO but not for 4M/8M
> 
> I think it would be interesting to have performance measurements with
> a RAM disk as target too because it is hard to tell for someone not
> familiar with the internals of the target used in this test which
> performance gain is due to the initiator changes and which is due to
> the target behavior.

I think it is pretty obvious that the gain is due to the initiator
changes allowing us to drive the target the way it likes to be driven,
but perhaps I haven't given you enough information. The HW is backed by
a RAID6 (really RAID3 + two parity drives). Each 4 KB block is broken
into stripes across 8 512 byte sectors, and there is no write combining
when the write cache is disabled. So, when we're splitting 1 MB into a
1020 KB and a 4 KB request, that translates into a 127.5 KB and a 512
byte request to each backend storage device. With the patches, that
remains a single 128 KB request, or 256KB for 2M, etc. The low level
drives can optimize that much better.

I did runs against my IOP test harness, and it showed better performance
there as well, though that was unexpected -- I figured we'd see a slight
decline in IOPS. I have not yet investigated further, but you have the
code and are welcome to run tests and report results.
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
