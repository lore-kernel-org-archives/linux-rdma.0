From: Tom Ammon <tom.ammon-wbocuHtxKic@public.gmane.org>
Subject: IB perf test questions
Date: Wed, 14 Jul 2010 14:28:15 -0600
Message-ID: <4C3E1DDF.1090305@utah.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  Hi,

I have done some benchmarking on a QDR fabric, and I wonder if someone 
could help me with a few questions.

Using ib_read_bw between 2 QDR nodes with a single switch between them, 
I get the following results:

[root@taildrop ~]# ib_write_bw -m 4096 -a -n 10000 155.101.5.4 -q 4
------------------------------------------------------------------
                     RDMA_Write BW Test
Number of qp's running 4
Connection type : RC
Each Qp will post up to 100 messages each time
Inline data is used up to 0 bytes message
  local address: LID 0x04 QPN 0x14004e PSN 0x94bcad RKey 0x48042000 
VAddr 0x002b8105a27000
  local address: LID 0x04 QPN 0x14004f PSN 0x1b2d93 RKey 0x48042000 
VAddr 0x002b8105a27000
  local address: LID 0x04 QPN 0x140050 PSN 0x79fae1 RKey 0x48042000 
VAddr 0x002b8105a27000
  local address: LID 0x04 QPN 0x140051 PSN 0xe8971c RKey 0x48042000 
VAddr 0x002b8105a27000
  remote address: LID 0x03 QPN 0x54004e PSN 0x2baff9 RKey 0x50042000 
VAddr 0x002ac8321f7000
  remote address: LID 0x03 QPN 0x54004f PSN 0x7d8026 RKey 0x50042000 
VAddr 0x002ac8321f7000
  remote address: LID 0x03 QPN 0x540050 PSN 0x94c242 RKey 0x50042000 
VAddr 0x002ac8321f7000
  remote address: LID 0x03 QPN 0x540051 PSN 0x662e32 RKey 0x50042000 
VAddr 0x002ac8321f7000
Mtu : 4096
------------------------------------------------------------------
  #bytes #iterations    BW peak[MB/sec]    BW average[MB/sec]
       2        10000               7.24                  7.23
       4        10000              14.55                 14.54
       8        10000              29.10                 29.07
      16        10000              58.37                 57.89
      32        10000             114.54                114.40
      64        10000             231.57                231.39
     128        10000             443.32                435.70
     256        10000             805.18                788.10
     512        10000             797.66                789.05
    1024        10000             790.05                788.34
    2048        10000            2804.49               2802.98
    4096        10000            2863.22               2862.29
    8192        10000            2895.43               2895.26
   16384        10000            2917.64               2917.42
   32768        10000            2924.17               2924.13
   65536        10000            2927.74               2927.73
  131072        10000            2928.85               2928.84
  262144        10000            2929.42               2929.41
  524288        10000            2929.78               2929.77
1048576        10000            2929.95               2929.95
2097152        10000            2930.02               2930.01
4194304        10000            2929.87               2929.87
8388608        10000            2929.78               2929.78
------------------------------------------------------------------


2930 MB/s = ~23 Gb/s. This seems reasonably close to the QDR line speed 
of 32Gb/s (not counting encoding overhead). The nodes are pretty new 
Dell c6100s with 4 x 4 Intel X5560 (2.8GHz) and 12GB of RAM. Does this 
look like a normal number for this kind of machine? Or am I missing 
something obvious to make it perform better?

Also, whether I use ib_read_bw or ib_write_bw, the machine I initiate 
the test from (in this case "taildrop") shows one of its CPU cores 
pegged at 100% for the duration of the test, but I see no CPU 
utilization at all on the receiving node. Can someone explain to me 
what's going on under the hood, here? I would think that read_bw would 
load up the sending host but that write_bw would load up the receiving 
host (or maybe vice versa), so this seems counterintuitive to me. when I 
use the -b flag to do a bidirectional test, a single CPU core on both 
machines pegs at 100%.

Thanks,

Tom

-- 
Tom Ammon
Network Engineer
Office: 801.587.0976
Mobile: 801.674.9273

Center for High Performance Computing
University of Utah
http://www.chpc.utah.edu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
