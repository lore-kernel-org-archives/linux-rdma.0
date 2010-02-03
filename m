From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 0/2] Using multi-smps on the wire in libibnetdisc
Date: Tue, 2 Feb 2010 16:45:14 -0800
Message-ID: <20100202164514.bf2b152a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha,

Following up on our thread regarding having multiple outstanding SMP's in libibnetdisc.

These 2 patches implement that as well as add a function to set the max outstanding the lib will use.

I left the default here to be 4.  On a large cluster there seems to be some variance with using 8 or 12.  Sometimes I get a speed up over 4 and other times I don't see any.  I think it has to do with the traffic on the fabric at any particular time.

For example here are some runs I just did on Hyperion.

14:31:55 > /usr/sbin/ibqueryerrors  -s RcvErrors,SymbolErrors,RcvSwRelayErrors,XmtWait -r --data 
Suppressing: RcvErrors SymbolErrors RcvSwRelayErrors XmtWait
Errors for 0x66a00d90006fb "SW19"
   GUID 0x66a00d90006fb port 9: [VL15Dropped == 3] [XmtData == 14562048] [RcvData == 14563872] [XmtPkts == 202255] [RcvPkts == 202276]
       Link info:    139   9[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>  0x0002c9030001d736    864    1[  ] "hyperion1" ( )

14:32:02 > time ./ibnetdiscover -o 8 --node-name-map /etc/opensm/ib-node-name-map -g > new

real    0m2.210s
user    0m1.251s
sys     0m0.869s

14:40:36 > time ./ibnetdiscover -o 4 --node-name-map /etc/opensm/ib-node-name-map -g > new

real    0m3.385s
user    0m1.888s
sys     0m1.448s

14:40:46 > time ./ibnetdiscover -o 4 --node-name-map /etc/opensm/ib-node-name-map -g > new

real    0m2.211s
user    0m1.165s
sys     0m0.951s

14:40:51 > time ./ibnetdiscover -o 8 --node-name-map /etc/opensm/ib-node-name-map -g > new

real    0m2.249s
user    0m1.244s
sys     0m0.936s

14:40:59 > time ./ibnetdiscover -o 4 --node-name-map /etc/opensm/ib-node-name-map -g > new

real    0m2.170s
user    0m1.160s
sys     0m0.933s

14:41:10 > /usr/sbin/ibqueryerrors  -s RcvErrors,SymbolErrors,RcvSwRelayErrors,XmtWait -r --data 
Suppressing: RcvErrors SymbolErrors RcvSwRelayErrors XmtWait
Errors for 0x66a00d90006fb "SW19"
   GUID 0x66a00d90006fb port 9: [VL15Dropped == 3] [XmtData == 25187379] [RcvData == 25196688] [XmtPkts == 349861] [RcvPkts == 349954]
       Link info:    139   9[  ] ==( 4X 5.0 Gbps Active/  LinkUp)==>  0x0002c9030001d736    864    1[  ] "hyperion1" ( )

Note that there were no additional VL15Dropped packets on the fabric.  I think 4 seems to be a good compromise.  I have not tested when there are errors on the fabric.  (Right now things seem to be good!)

The first patch converts the algorithm and the second adds the ibnd_set_max_smps_on_wire call.

Let me know what you think.  Because the algorithm changed so much testing this is a bit difficult because the order of the node discovery is different.  However, I have done some extensive diffing of the output of ibnetdiscover and things look good.

Ira

-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
