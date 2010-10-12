From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [opensm] RFC: new routing options
Date: Tue, 12 Oct 2010 09:43:27 -0700
Message-ID: <1286901808.12737.55.camel@auk31.llnl.gov>
References: <1286559644.12737.38.camel@auk31.llnl.gov>
	 <4CB4155A.3030904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CB4155A.3030904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Yevgeny,

Yes, I tried that and it didn't have much of an effect.  Ever since
Sasha put in his routing sorted by switch load
(sort_ports_by_switch_load() in osm_ucast_mgr.c), guid_routing_order
isn't really necessary (as long as most of the cluster is up).

Al

On Tue, 2010-10-12 at 00:59 -0700, Yevgeny Kliteynik wrote:
> Hi Al,
> 
> This looks really great!
> One question: have you tried benchmarking the BW with up/down
> routing using the guid_routing_order_file option w/o your new
> features?
> 
> -- YK
> 
> On 08-Oct-10 7:40 PM, Albert Chu wrote:
> > Hey Sasha,
> > 
> > We recently got a new cluster and I've been experimenting with some
> > routing changes to improve the average bandwidth of the cluster.  They
> > are attached as patches with description of the routing goals below.
> > 
> > We're using mpiGraph (http://BLOCKEDsourceforge.net/projects/mpigraph/) to
> > measure min, peak, and average send/recv bandwidth across the cluster.
> > What we found with the original updn routing was an average of around
> > 420 MB/s send bandwidth and 508 MB/s recv bandwidth.  The following two
> > patches were able to get the average send bandwidth up to 1045 MB/s and
> > recv bandwidth up to 1228 MB/s.
> > 
> > I'm sure this is only round 1 of the patches and I'm looking for
> > comments.  Many areas could be cleaned up w/ some rearchitecture or
> > struct changes, but I simply implemented the most non-invasive
> > implementation first.  I'm also open to name changes on the options.
> > 
> > BTW, b/c of the old management tree on the git server, the following
> > patches were developed on an internal LLNL tree.  I'll rebase after the
> > up2date tree is on the openfabrics server.
> > 
> > 1) Port Shifting
> > 
> > This is similar to what was done with some of the LMC>  0 code.
> > Congestion would occur due to "alignment" of routes w/ common traffic
> > patterns.  However, we found that it was also necessary for LMC=0 and
> > only for used-ports.  For example, lets say there are 4 ports (called A,
> > B, C, D) and we are routing lids 1-9 through them.  Suppose only routing
> > through A, B, and C will reach lids 1-9.
> > 
> > The LFT would normally be:
> > 
> > A: 1 4 7
> > B: 2 5 8
> > C: 3 6 9
> > D:
> > 
> > The Port Shifting would make this:
> > 
> > A: 1 6 8
> > B: 2 4 9
> > C: 3 5 7
> > D:
> > 
> > This option by itself improved the mpiGraph average send/recv bandwidth
> > from 420 MB/s and 508 MB/s to to 991 MB/s and 1172 MB/s.
> > 
> > 2) Remote Guid Sorting
> > 
> > Most core/spine switches we've seen have had line boards connected to
> > spine boards in a consistent pattern.  However, we recently got some
> > Qlogic switches that connect from line/leaf boards to spine boards in a
> > (to the casual observer) random pattern.  I'm sure there was a good
> > electrical/board reason for this design, but it does hurt routing b/c
> > some of the opensm routing algorithms didn't account for this
> > assumption.  Here's an output from iblinkinfo as an example.
> > 
> > Switch 0x00066a00ec0029b8 ibcore1 L123:
> >           180    1[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      254   19[  ] "ibsw55" ( )
> >           180    2[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      253   19[  ] "ibsw56" ( )
> >           180    3[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      258   19[  ] "ibsw57" ( )
> >           180    4[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      257   19[  ] "ibsw58" ( )
> >           180    5[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      256   19[  ] "ibsw59" ( )
> >           180    6[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      255   19[  ] "ibsw60" ( )
> >           180    7[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      261   19[  ] "ibsw61" ( )
> >           180    8[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      262   19[  ] "ibsw62" ( )
> >           180    9[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      260   19[  ] "ibsw63" ( )
> >           180   10[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      259   19[  ] "ibsw64" ( )
> >           180   11[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      284   19[  ] "ibsw65" ( )
> >           180   12[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      285   19[  ] "ibsw66" ( )
> >           180   13[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>     2227   19[  ] "ibsw67" ( )
> >           180   14[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      283   19[  ] "ibsw68" ( )
> >           180   15[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      267   19[  ] "ibsw69" ( )
> >           180   16[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      270   19[  ] "ibsw70" ( )
> >           180   17[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      269   19[  ] "ibsw71" ( )
> >           180   18[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      268   19[  ] "ibsw72" ( )
> >           180   19[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      222   17[  ] "ibcore1 S117B" ( )
> >           180   20[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      209   19[  ] "ibcore1 S211B" ( )
> >           180   21[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      218   21[  ] "ibcore1 S117A" ( )
> >           180   22[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      192   23[  ] "ibcore1 S215B" ( )
> >           180   23[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>       85   15[  ] "ibcore1 S209A" ( )
> >           180   24[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      182   13[  ] "ibcore1 S215A" ( )
> >           180   25[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      200   11[  ] "ibcore1 S115B" ( )
> >           180   26[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      129   25[  ] "ibcore1 S209B" ( )
> >           180   27[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      213   27[  ] "ibcore1 S115A" ( )
> >           180   28[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      197   29[  ] "ibcore1 S213B" ( )
> >           180   29[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      178   28[  ] "ibcore1 S111A" ( )
> >           180   30[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      215    7[  ] "ibcore1 S213A" ( )
> >           180   31[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      207    5[  ] "ibcore1 S113B" ( )
> >           180   32[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      212    6[  ] "ibcore1 S211A" ( )
> >           180   33[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      154   33[  ] "ibcore1 S113A" ( )
> >           180   34[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      194   35[  ] "ibcore1 S217B" ( )
> >           180   35[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      191    3[  ] "ibcore1 S111B" ( )
> >           180   36[  ] ==( 4X 10.0 Gbps Active/  LinkUp)==>      219    1[  ] "ibcore1 S217A" ( )
> > 
> > This is a line board that connects up to spine boards (ibcore1 S*
> > switches) and down to leaf/edge switches (ibsw*).  As you can see the
> > line board connects to the ports on the spine switches in a random
> > fashion (to the casual observer).
> > 
> > The "remote_guid_sorting" option will slightly tweak routing so that
> > instead of finding a port to route through by searching ports 1 to N. It
> > will (effectively) sort the ports based on remote connected node guid,
> > then pick a port searching from lowest guid to highest guid. That way
> > the routing calculations across each line/leaf board and spine switch
> > will be consistent.
> > 
> > This patch (on top of the port_shifting one above) improved the mpiGraph
> > average send/recv bandwidth from 991 MB/s&  1172 MB/s to 1045 MB/s and
> > 1228 MB/s.
> > 
> > Al
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://BLOCKEDvger.kernel.org/majordomo-info.html
> 
-- 
Albert Chu
chu11-i2BcT+NCU+M@public.gmane.org
Computer Scientist
High Performance Systems Division
Lawrence Livermore National Laboratory

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
