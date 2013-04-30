From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: NFS over RDMA benchmark
Date: Tue, 30 Apr 2013 09:38:18 -0400
Message-ID: <20130430133818.GU17268@fieldses.org>
References: <CABgxfbF7c9ktSoMSPV21JU76V5J4iwbJQ257S91Y3z36WJbJVA@mail.gmail.com>
 <62745258-4F3B-4C05-BFFD-03EA604576E4@ornl.gov>
 <CABgxfbGxhnKj2n0Z-w87rZ6fwCssO31G009gwej957gv1p8PQQ@mail.gmail.com>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF9715B@MTLDAG01.mtl.com>
 <20130423210607.GJ3676@fieldses.org>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF988C9@MTLDAG01.mtl.com>
 <20130424150540.GB20275@fieldses.org>
 <20130424152631.GC20275@fieldses.org>
 <0EE9A1CDC8D6434DB00095CD7DB873462CF9A820@MTLDAG01.mtl.com>
 <20130428144248.GA2037@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130428144248.GA2037-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yan Burman <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 28, 2013 at 10:42:48AM -0400, J. Bruce Fields wrote:
> On Sun, Apr 28, 2013 at 06:28:16AM +0000, Yan Burman wrote:
> > > > > > > > >> On Wed, Apr 17, 2013 at 7:36 AM, Yan Burman
> > > > > > > > >> <yanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > > > > >>> I've been trying to do some benchmarks for NFS over RDMA
> > > > > > > > >>> and I seem to
> > > > > > > > only get about half of the bandwidth that the HW can give me.
> > > > > > > > >>> My setup consists of 2 servers each with 16 cores, 32Gb of
> > > > > > > > >>> memory, and
> > > > > > > > Mellanox ConnectX3 QDR card over PCI-e gen3.
> > > > > > > > >>> These servers are connected to a QDR IB switch. The
> > > > > > > > >>> backing storage on
> > > > > > > > the server is tmpfs mounted with noatime.
> > > > > > > > >>> I am running kernel 3.5.7.
> > > > > > > > >>>
> > > > > > > > >>> When running ib_send_bw, I get 4.3-4.5 GB/sec for block sizes 4-
> > > 512K.
> > > > > > > > >>> When I run fio over rdma mounted nfs, I get 260-2200MB/sec
> > > > > > > > >>> for the
> > > > > > > > same block sizes (4-512K). running over IPoIB-CM, I get 200-
> > > 980MB/sec.
> ...
> > > > > > > I am trying to get maximum performance from a single server - I
> > > > > > > used 2
> > > > > > processes in fio test - more than 2 did not show any performance boost.
> > > > > > > I tried running fio from 2 different PCs on 2 different files,
> > > > > > > but the sum of
> > > > > > the two is more or less the same as running from single client PC.
> > > > > > >
> > > > > > > What I did see is that server is sweating a lot more than the
> > > > > > > clients and
> > > > > > more than that, it has 1 core (CPU5) in 100% softirq tasklet:
> > > > > > > cat /proc/softirqs
> ...
> > > > > Perf top for the CPU with high tasklet count gives:
> > > > >
> > > > >              samples  pcnt         RIP        function                    DSO
> ...
> > > > >              2787.00 24.1% ffffffff81062a00 mutex_spin_on_owner
> > > /root/vmlinux
> ...
> > > Googling around....  I think we want:
> > > 
> > > 	perf record -a --call-graph
> > > 	(give it a chance to collect some samples, then ^C)
> > > 	perf report --call-graph --stdio
> > > 
> > 
> > Sorry it took me a while to get perf to show the call trace (did not enable frame pointers in kernel and struggled with perf options...), but what I get is:
> >     36.18%          nfsd  [kernel.kallsyms]   [k] mutex_spin_on_owner
> >                     |
> >                     --- mutex_spin_on_owner
> >                        |
> >                        |--99.99%-- __mutex_lock_slowpath
> >                        |          mutex_lock
> >                        |          |
> >                        |          |--85.30%-- generic_file_aio_write
> 
> That's the inode i_mutex.

Looking at the code....  With CONFIG_MUTEX_SPIN_ON_OWNER it spins
(instead of sleeping) as long as the lock owner's still running.  So
this is just a lot of contention on the i_mutex, I guess.  Not sure what
to do aobut that.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
