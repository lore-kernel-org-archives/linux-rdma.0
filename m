From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix request completion holes
Date: Wed, 1 Nov 2017 18:09:05 +0200
Message-ID: <510ae9b0-4aa4-35ee-58ff-50d58d358fbb@mellanox.com>
References: <1509440122-1190-1-git-send-email-sagi@grimberg.me>
 <8abcde91-9150-2982-3900-078619bcdac0@mellanox.com>
 <a950a671-22a1-432c-555e-8309c8a64a88@grimberg.me>
 <d9dcdb05-d001-53d8-7ed7-5fafc1709f4a@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------74F290E53DE0F4EB7F8D6B99"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d9dcdb05-d001-53d8-7ed7-5fafc1709f4a-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: he
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: idanb <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--------------74F290E53DE0F4EB7F8D6B99
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit



On 11/1/2017 6:02 PM, idanb wrote:
> Sagi,
> 
> Thanks for you patches, Max and me ran your patches adding completion 
> signaling for both send (command capsule) and local invalidation request.
> 
> The results were significant reduction of IOPs due to interrupts and 
> completion processing, see below our results for READ/WRITE IOPs (512B, 
> 64 Jobs):
> 
> (1) No send signal and no invalidation signal w/ moderation 7.4M / 11.9M
> 
> (2) No send signal and no invalidation signal w/o moderation 7.1M / 8.7M
> 
> (3) No send signal with invalidation signal w/o moderation 5.2M / 8.3M
> 
> (4) Send signal with invalidation signal w/o moderation 3.4M / 4.6M
> 
> (5) Send signal with invalidation signal w/ moderation 6.2M / 11.8M
> 
> 
> I understand that (1), (2) and (3) are invalid, the performance 
> reduction induce by mode (4) need to motivate us to enable cqe/event 
> moderation as soon as possible.
> 

attached the full report we ran with Sagi's patches (+ cq moderation 
cases with cq_completions=32 cq_timeout=16 + old send signal [once in 
queue_size/2])

--------------74F290E53DE0F4EB7F8D6B99
Content-Type: text/plain; charset="UTF-8"; name="final_report.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="final_report.log"

READ: Signal with moderation
+++++++++++++++++++++++++++++++
read (512B, 32 CPUs, 32 jobs, iodepth=128): io=61146MB, bw=3057.2MB/s, iops=6261.9K, runt= 20001msec
read (1k, 32 CPUs, 32 jobs, iodepth=128) : io=110943MB, bw=5546.1MB/s, iops=5680.2K, runt= 20001msec
read (2k, 32 CPUs, 32 jobs, iodepth=128): io=163192MB, bw=8159.3MB/s, iops=4177.6K, runt= 20001msec
read (4k, 32 CPUs, 32 jobs, iodepth=128): io=177120MB, bw=8855.2MB/s, iops=2266.1K, runt= 20002msec
read (8k, 32 CPUs, 32 jobs, iodepth=128): io=187884MB, bw=9392.9MB/s, iops=1202.3K, runt= 20003msec
read (16k, 32 CPUs, 32 jobs, iodepth=128): io=190151MB, bw=9505.7MB/s, iops=608359, runt= 20004msec
read (32k, 32 CPUs, 32 jobs, iodepth=128): io=191209MB, bw=9556.7MB/s, iops=305812, runt= 20008msec
read (64k, 32 CPUs, 32 jobs, iodepth=128): io=192417MB, bw=9611.8MB/s, iops=153787, runt= 20019msec
read (512B, 32 CPUs, 64 jobs, iodepth=128): io=34871MB, bw=1743.5MB/s, iops=3570.7K, runt= 20001msec
read (1k, 32 CPUs, 64 jobs, iodepth=128): io=106594MB, bw=5329.2MB/s, iops=5457.8K, runt= 20002msec
read (2k, 32 CPUs, 64 jobs, iodepth=128): io=153952MB, bw=7696.9MB/s, iops=3940.8K, runt= 20002msec
read (4k, 32 CPUs, 64 jobs, iodepth=128): io=171229MB, bw=8560.2MB/s, iops=2191.4K, runt= 20003msec
read (8k, 32 CPUs, 64 jobs, iodepth=128): io=178982MB, bw=8946.9MB/s, iops=1145.2K, runt= 20005msec
read (16k, 32 CPUs, 64 jobs, iodepth=128): io=182606MB, bw=9126.2MB/s, iops=584076, runt= 20009msec
read (32k, 32 CPUs, 64 jobs, iodepth=128): io=183271MB, bw=9157.2MB/s, iops=293028, runt= 20014msec
read (64k, 32 CPUs, 64 jobs, iodepth=128): io=169174MB, bw=8447.3MB/s, iops=135156, runt= 20027msec

READ: Signal without moderation
++++++++++++++++++++++++++++++++
read : io=33410MB, bw=1670.5MB/s, iops=3420.1K, runt= 20001msec
read : io=66287MB, bw=3314.2MB/s, iops=3393.8K, runt= 20001msec
read : io=128976MB, bw=6448.5MB/s, iops=3301.7K, runt= 20001msec
read : io=172651MB, bw=8631.8MB/s, iops=2209.8K, runt= 20002msec
read : io=181532MB, bw=9076.2MB/s, iops=1161.8K, runt= 20001msec
read : io=194935MB, bw=9744.9MB/s, iops=623667, runt= 20004msec
read : io=192299MB, bw=9610.7MB/s, iops=307540, runt= 20009msec
read : io=192919MB, bw=9635.9MB/s, iops=154173, runt= 20021msec
read : io=31905MB, bw=1595.2MB/s, iops=3266.1K, runt= 20001msec
read : io=69284MB, bw=3464.2MB/s, iops=3547.2K, runt= 20001msec
read : io=146078MB, bw=7303.2MB/s, iops=3739.3K, runt= 20002msec
read : io=168585MB, bw=8428.4MB/s, iops=2157.6K, runt= 20003msec
read : io=181224MB, bw=9058.1MB/s, iops=1159.6K, runt= 20005msec
read : io=184970MB, bw=9244.4MB/s, iops=591638, runt= 20009msec
read : io=184823MB, bw=9234.8MB/s, iops=295510, runt= 20014msec
read : io=175313MB, bw=8753.4MB/s, iops=140054, runt= 20028msec

READ: No SEND Signal with moderation (with signal on local invalidation)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
read : io=61968MB, bw=3098.3MB/s, iops=6345.3K, runt= 20001msec
read : io=112583MB, bw=5628.9MB/s, iops=5763.1K, runt= 20001msec
read : io=167024MB, bw=8350.9MB/s, iops=4275.7K, runt= 20001msec
read : io=181638MB, bw=9081.1MB/s, iops=2324.8K, runt= 20002msec
read : io=185373MB, bw=9267.3MB/s, iops=1186.3K, runt= 20003msec
read : io=191548MB, bw=9575.6MB/s, iops=612832, runt= 20004msec
read : io=190085MB, bw=9499.2MB/s, iops=303999, runt= 20009msec
read : io=192519MB, bw=9616.9MB/s, iops=153868, runt= 20019msec
read : io=58495MB, bw=2924.6MB/s, iops=5989.6K, runt= 20001msec
read : io=109628MB, bw=5480.9MB/s, iops=5612.4K, runt= 20002msec
read : io=156339MB, bw=7816.6MB/s, iops=4002.8K, runt= 20001msec
read : io=171421MB, bw=8569.9MB/s, iops=2193.9K, runt= 20003msec
read : io=179565MB, bw=8976.3MB/s, iops=1148.1K, runt= 20005msec
read : io=182728MB, bw=9132.8MB/s, iops=584495, runt= 20008msec
read : io=184840MB, bw=9235.2MB/s, iops=295551, runt= 20013msec
read : io=180544MB, bw=9015.8MB/s, iops=144240, runt= 20027msec

READ: No SEND Signal without moderation (with signal on local invalidation)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
read : io=40289MB, bw=2014.4MB/s, iops=4125.5K, runt= 20001msec
read : io=78689MB, bw=3934.3MB/s, iops=4028.7K, runt= 20001msec
read : io=143805MB, bw=7189.1MB/s, iops=3681.3K, runt= 20001msec
read : io=173558MB, bw=8677.4MB/s, iops=2221.4K, runt= 20002msec
read : io=186197MB, bw=9308.5MB/s, iops=1191.5K, runt= 20003msec
read : io=192793MB, bw=9637.8MB/s, iops=616812, runt= 20004msec
read : io=192399MB, bw=9616.1MB/s, iops=307714, runt= 20008msec
read : io=194790MB, bw=9731.8MB/s, iops=155707, runt= 20016msec
read : io=50862MB, bw=2542.2MB/s, iops=5208.3K, runt= 20001msec
read : io=103616MB, bw=5180.6MB/s, iops=5304.9K, runt= 20001msec
read : io=150399MB, bw=7519.3MB/s, iops=3849.9K, runt= 20002msec
read : io=173678MB, bw=8682.2MB/s, iops=2222.7K, runt= 20004msec
read : io=181481MB, bw=9071.9MB/s, iops=1161.2K, runt= 20005msec
read : io=186601MB, bw=9326.4MB/s, iops=596884, runt= 20008msec
read : io=187268MB, bw=9356.9MB/s, iops=299419, runt= 20014msec
read : io=176620MB, bw=8817.4MB/s, iops=141077, runt= 20031msec

Write: Signal with moderation
+++++++++++++++++++++++++++++++
write: io=115326MB, bw=5766.2MB/s, iops=11809K, runt= 20001msec
write: io=148240MB, bw=7411.7MB/s, iops=7589.6K, runt= 20001msec
write: io=161919MB, bw=8095.6MB/s, iops=4144.1K, runt= 20001msec
write: io=171162MB, bw=8557.3MB/s, iops=2190.7K, runt= 20002msec
write: io=199720MB, bw=9984.6MB/s, iops=1278.2K, runt= 20003msec
write: io=206792MB, bw=10338MB/s, iops=661600, runt= 20004msec
write: io=209549MB, bw=10474MB/s, iops=335161, runt= 20007msec
write: io=208180MB, bw=10402MB/s, iops=166427, runt= 20014msec
write: io=46900MB, bw=2344.1MB/s, iops=4802.4K, runt= 20001msec
write: io=105243MB, bw=5261.1MB/s, iops=5388.2K, runt= 20001msec
write: io=160543MB, bw=8026.4MB/s, iops=4109.6K, runt= 20002msec
write: io=174457MB, bw=8721.2MB/s, iops=2232.7K, runt= 20004msec
write: io=192598MB, bw=9627.2MB/s, iops=1232.4K, runt= 20004msec
write: io=201587MB, bw=10076MB/s, iops=644851, runt= 20007msec
write: io=205567MB, bw=10272MB/s, iops=328693, runt= 20013msec
write: io=208508MB, bw=10412MB/s, iops=166590, runt= 20026msec

Write: Signal without moderation
+++++++++++++++++++++++++++++++++
write: io=43445MB, bw=2172.2MB/s, iops=4448.6K, runt= 20001msec
write: io=93361MB, bw=4667.9MB/s, iops=4779.9K, runt= 20001msec
write: io=160929MB, bw=8046.6MB/s, iops=4119.6K, runt= 20001msec
write: io=171522MB, bw=8575.3MB/s, iops=2195.3K, runt= 20002msec
write: io=198314MB, bw=9914.2MB/s, iops=1269.2K, runt= 20003msec
write: io=206332MB, bw=10315MB/s, iops=660129, runt= 20004msec
write: io=207733MB, bw=10383MB/s, iops=332240, runt= 20008msec
write: io=208141MB, bw=10399MB/s, iops=166379, runt= 20016msec
write: io=45763MB, bw=2288.2MB/s, iops=4685.9K, runt= 20001msec
write: io=100083MB, bw=5003.1MB/s, iops=5123.1K, runt= 20001msec
write: io=159084MB, bw=7953.5MB/s, iops=4072.2K, runt= 20002msec
write: io=173523MB, bw=8674.5MB/s, iops=2220.7K, runt= 20004msec
write: io=189560MB, bw=9476.2MB/s, iops=1212.1K, runt= 20004msec
write: io=199250MB, bw=9958.6MB/s, iops=637344, runt= 20008msec
write: io=204977MB, bw=10243MB/s, iops=327767, runt= 20012msec
write: io=208619MB, bw=10417MB/s, iops=166678, runt= 20026msec

Write: No SEND Signal with moderation (with signal on local invalidation)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
write: io=116784MB, bw=5838.1MB/s, iops=11958K, runt= 20001msec
write: io=143658MB, bw=7182.6MB/s, iops=7354.1K, runt= 20001msec
write: io=161343MB, bw=8066.4MB/s, iops=4129.1K, runt= 20002msec
write: io=170761MB, bw=8537.3MB/s, iops=2185.6K, runt= 20002msec
write: io=199668MB, bw=9982.5MB/s, iops=1277.8K, runt= 20002msec
write: io=207307MB, bw=10363MB/s, iops=663248, runt= 20004msec
write: io=209903MB, bw=10491MB/s, iops=335727, runt= 20007msec
write: io=208268MB, bw=10406MB/s, iops=166489, runt= 20015msec
write: io=87286MB, bw=4364.1MB/s, iops=8937.7K, runt= 20001msec
write: io=145686MB, bw=7283.6MB/s, iops=7458.4K, runt= 20002msec
write: io=160259MB, bw=8012.2MB/s, iops=4102.3K, runt= 20002msec
write: io=174527MB, bw=8724.7MB/s, iops=2233.5K, runt= 20004msec
write: io=193620MB, bw=9679.5MB/s, iops=1238.1K, runt= 20004msec
write: io=202051MB, bw=10099MB/s, iops=646336, runt= 20007msec
write: io=206876MB, bw=10337MB/s, iops=330770, runt= 20014msec
write: io=208138MB, bw=10394MB/s, iops=166302, runt= 20025msec

Write: No SEND Signal without moderation (with signal on local invalidation)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
write: io=73271MB, bw=3663.4MB/s, iops=7502.6K, runt= 20001msec
write: io=129638MB, bw=6481.6MB/s, iops=6637.2K, runt= 20001msec
write: io=161002MB, bw=8049.3MB/s, iops=4121.3K, runt= 20002msec
write: io=170759MB, bw=8537.1MB/s, iops=2185.5K, runt= 20002msec
write: io=198565MB, bw=9927.3MB/s, iops=1270.7K, runt= 20002msec
write: io=207304MB, bw=10363MB/s, iops=663239, runt= 20004msec
write: io=207251MB, bw=10358MB/s, iops=331468, runt= 20008msec
write: io=208262MB, bw=10405MB/s, iops=166484, runt= 20015msec
write: io=81719MB, bw=4085.8MB/s, iops=8367.6K, runt= 20001msec
write: io=145468MB, bw=7273.2MB/s, iops=7447.6K, runt= 20001msec
write: io=159924MB, bw=7995.5MB/s, iops=4093.7K, runt= 20002msec
write: io=174306MB, bw=8713.6MB/s, iops=2230.7K, runt= 20004msec
write: io=186670MB, bw=9333.3MB/s, iops=1194.7K, runt= 20001msec
write: io=201011MB, bw=10047MB/s, iops=642978, runt= 20008msec
write: io=206175MB, bw=10303MB/s, iops=329681, runt= 20012msec
write: io=208853MB, bw=10430MB/s, iops=166882, runt= 20024msec

--------------74F290E53DE0F4EB7F8D6B99--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
