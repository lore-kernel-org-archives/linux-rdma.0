From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: RDMA performance comparison: IBNBD, SCST, NVMEoF
Date: Tue, 18 Apr 2017 19:33:25 +0200
Message-ID: <CAJrWOzAM_A6fwFxTZVo9MmiwWF1d6Bp9zTdBvUfnDFCPY_CmCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Fabian Holler <mail@fholler.de>, Milind Dumbare <Milind.dumbare@gmail.com>, Michael Wang <yun.wang@profitbricks.com>, Danil Kipnis <danil.kipnis@profitbricks.com>, Jinpu Wang <jinpu.wang@profitbricks.com>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Bart, Sagi and all,

By current email I would like to share some fresh RDMA performance
results of IBNBD, SCST and NVMEof, based on 4.10 kernel and variety
of configurations.

All fio runs are grouped by the name of a project, crucial config
differencies (e.g. CPU pinning or register_always=3DN) and two testing
modes: MANY-DISKS and MANY-JOBS.  In each group of results amount of
simultaneous fio jobs is increasing starting from 1 up to 128.  E.g.
in MANY-DISKS testing mode 1 fio job is dedicated to 1 disk, where
amount of jobs (and disks) is growing, in its turn, in MANY-JOBS
testing mode each fio job produces IO for the same disk, i.e.:

  MANY-DISKS:
     x1:
         numjobs=3D1
         [job1]
         filename=3D/dev/nvme0n1
     ...
     x128:
         numjobs=3D1
         [job1]
         filename=3D/dev/nvme0n1
         [job2]
         filename=3D/dev/nvme0n2
         ...
         [job128]
         filename=3D/dev/nvme0n128

  MANY-JOBS:
     x1:
         numjobs=3D1
         [job1]
         filename=3D/dev/nvme0n1
     ...
     x128:
         numjobs=3D128
         [job1]
         filename=3D/dev/nvme0n1

Each group of results represents itself as a performance measurement,
which can be easily plotted, taking number of jobs as X axis and iops,
overall IO latencies or anything else extracted from fio json result
files as Y axis.

FIO configurations were generated and saved along with produced fio
json results by the fio-runner.py script [1].  Complete archive with
FIO configs and results can be downloaded here [2].

The following metrics were taken from fio json results:

    write/iops     - IOPS
    write/lat/mean - average latency (=CE=BCs)

Here I would like to present reduced results table taking into account
only runs with CPU pinning in MANY-DISKS testing mode, since CPU pinning
makes more sense in terms of performance and MANY-DISKS and MANY-JOBS
results look very much similar:

write/iops (MANY-DISKS)
      IBNBD_pin   NVME_noreg_pin  NVME_pin    SCST_noreg_pin  SCST_pin
x1    80398.96    75577.24        54110.19    59555.04        48446.05
x2    109018.60   96478.45        69176.77    73925.81        55557.59
x4    169164.56   140558.75       93700.96    75419.91        56294.61
x8    197725.44   159887.33       99773.05    79750.92        55938.84
x16   176782.36   150448.33       99644.05    92964.23        56463.14
x32   139666.00   123198.38       81845.30    81287.98        50590.86
x64   125666.16   82231.77        72117.67    72023.32        45121.17
x128  120253.63   73911.97        65665.08    74642.27        47268.46

write/lat/mean (MANY-DISKS)
      IBNBD_pin   NVME_noreg_pin  NVME_pin    SCST_noreg_pin  SCST_pin
x1    647.78      697.91          1032.97     925.51          1173.04
x2    973.20      1104.38         1612.75     1462.18         2047.11
x4    1279.49     1528.09         2452.22     3188.41         4235.95
x8    2356.92     2929.87         4891.70     6248.85         8907.10
x16   5605.62     6575.70         10046.4     10830.50        17945.57
x32   14489.54    16516.60        24849.16    24984.26        40335.09
x64   32364.39    49481.42        56615.23    56559.02        90590.84
x128  67570.88    110768.70       124249.4    109321.84       171390.00

    * Where suffixes mean:

     _pin   - CPU pinning
     _noreg - modules on initiator side (ib_srp, nvme_rdma) were loaded
              with 'register_always=3DN' param

Complete table results and corresponding graphs are presented on Google
sheet [3].

Conclusion:
    IBNBD outperforms in average by:

                     NVME_noreg_pin  NVME_pin  SCST_noreg_pin  SCST_pin
       iops          41%             72%       61%             155%
       lat/mean      28%             42%       38%             60%

       * Complete tables results [3] were taken into account for average
         percentage calculation.

Test setup is the following:

Initiator and target HW configuration:

    AMD Opteron 6386 SE, 64CPU, 128Gb
    InfiniBand: Mellanox Technologies MT26428
                [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE]

Initiator and target SW configuration:

    vanilla Linux 4.10
    + IBNBD patches
    + SCST from https://github.com/bvanassche/scst, master branch

Initiator side:

    IBNBD and NVME: MQ mode
    SRP: default RQ, on attempt to set 'use_blk_mq=3DY' IO hangs.

    FIO generic configuration pattern:

        bssplit=3D512/20:1k/16:2k/9:4k/12:8k/19:16k/10:32k/8:64k/4
        fadvise_hint=3D0
        rw=3Drandrw:2
        direct=3D1
        random_distribution=3Dzipf:1.2
        time_based=3D1
        runtime=3D10
        ioengine=3Dlibaio
        iodepth=3D128
        iodepth_batch_submit=3D128
        iodepth_batch_complete=3D128
        group_reporting

Target side:

    128 null_blk devices with default configuration, opened as blockio.

NVMEoF configuration script [4].
SCST configuration script [5].


Would be great to receive any feedback.  I am open for further perf
tuning and testing with other possible configurations and options.

Thanks.

--
Roman

[1] FIO runner and results extractor script:
    https://drive.google.com/open?id=3D0B8_SivzwHdgSS2RKcmc4bWg0YjA

[2] Archive with FIO configurations and results:
    https://drive.google.com/open?id=3D0B8_SivzwHdgSaDlhMXV6THhoRXc

[3] Google sheet with performance measurements:
    https://drive.google.com/open?id=3D1sCTBKLA5gbhhkgd2USZXY43VL3zLidzdqDe=
ObZn9Edc

[4] NVMEoF configuration:
    https://drive.google.com/open?id=3D0B8_SivzwHdgSTzRjbGtmaVR6LWM

[5] SCST configuration:
    https://drive.google.com/open?id=3D0B8_SivzwHdgSM1B5eGpKWmFJMFk
