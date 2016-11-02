From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Wed, 2 Nov 2016 10:07:38 -0500
Message-ID: <004601d2351a$d9db85b0$8d929110$@opengridcomputing.com>
References: <01b401d23458$af277210$0d765630$@opengridcomputing.com> <6f42d056-284d-00fc-2b98-189f54957980@grimberg.me> <01cc01d2345b$d445acd0$7cd10670$@opengridcomputing.com> <4cc25277-429a-4ab9-470c-b3af1428ce93@grimberg.me> <01d101d2345e$2f054390$8d0fcab0$@opengridcomputing.com> <dbe5f18d-7928-f065-920f-753b30fb99a2@grimberg.me> <01d901d2345f$da0d2e00$8e278a00$@opengridcomputing.com> <1d09c064-1cbe-7e6e-43d2-cfa6cf0c19ea@grimberg.me> <024e01d23476$6668b890$333a29b0$@opengridcomputing.com> <3512b8bb-4d29-b90a-49e1-ebf1085c47d7@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3512b8bb-4d29-b90a-49e1-ebf1085c47d7-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > Hey Sagi.  I hit another crash on the target.  This was with 4.8.0 + the
patch
> > to skip disconnect events if the cm_id->qp is NULL. This time the crash is
in
> > _raw_spin_lock_irqsave() called by nvmet_rdma_recv_done().  The log is too
big
> > to include everything inline, but I'm attaching the full log as an
attachment.
> > Looks like at around 4988.169 seconds in the log, we see 5 controllers
created,
> > all named "controller 1"!  And 32 queues assigned to controller 1 5 times!
And
> > shortly after that we hit the BUG.
> 
> So I think you're creating multiple subsystems and provision each
> subsystem differently correct? the controller ids are unique within
> a subsystem so two different subsystems can have ctrl id 1. Perhaps
> our logging should mention the subsysnqn too?
> 

I'm not sure I understand the "subsystem" concept.  I never noticed before that
any target device had the same controller ID.  The target json config file is
inserted below.  There are 10 ramdisks exported over 2 ports of a cxgb4 40GE
device and 1 port of an mlx4 RoCE device.   For this test, the NVMF host
connects to all 10 targets over 1 port of the cxgb4 device.  Like this:

for i in $(seq 0 9) ; do nvme connect --transport=rdma --trsvcid=4420
--traddr=10.0.1.14 --nqn=test-ram${i}; done

> Anyway, is there traffic going on?
>

Yes, heavy fio on all 10 attached ramdisks.
 
> The only way we can get recv_done with corrupted data is if we posted
> something after the qp drain completed, can you check if that can happen?
>

Hmm, posting after the drain would result in a synchronous error returned by
ib_post_send() for cxgb4.  There is that issue with cxgb4's drain logic in that
it really only guarantees that the CQEs are polled, not that the completion
handler was called.  I have a fix in progress for this (actually decided to
support drain like IB does with a small delta from the iWARP spec).  I'll also
try and reproduce this on mlx4 to rule out iwarp and cxgb4 anomolies.  And I can
try my new drain fix which will be posted for review soon for inclusion into
4.10.
 
> Can you share your test case?

Of course!  This is the same test that was killing the host side very quickly,
until Christoph fixed it with:

http://lists.infradead.org/pipermail/linux-nvme/2016-November/007043.html

Now it runs for ~60-90 minutes before the target dies.  

After connecting all 10 ramdisks over 1 cxgb4 port, with 32 core NVMF
host/target nodes, you run this script (note nvme0n1 is a local nvme device, so
the NVMF devices are nvme[1-10]n1):

[root@stevo1 sw]# cat /root/bug30782/fio.sh
for i in $(seq 1 200) ; do

         fio --startdelay=1-10 --ioengine=libaio --rw=randwrite --name=randwrite
--size=200m --direct=1 \
        --invalidate=1 --fsync_on_close=1 --group_reporting --exitall
--runtime=60 \
        --time_based --filename=/dev/nvme10n1 --filename=/dev/nvme1n1 \
        --filename=/dev/nvme2n1 --filename=/dev/nvme3n1 --filename=/dev/nvme4n1
\
        --filename=/dev/nvme5n1 --filename=/dev/nvme6n1 --filename=/dev/nvme7n1
\
        --filename=/dev/nvme8n1 --filename=/dev/nvme9n1 --iodepth=4 --numjobs=32
\
        --bs=2K |grep -i "aggrb\|iops"
        sleep 3
        echo "### Iteration $i Done ###"
done

And then run this script (eth2 is the port handling the NVMF traffic) to force
keep alive timeouts and reconnects:

while : ; do
    ifconfig eth2 down
    sleep $(( ($RANDOM & 0xf) + 8 ))
    ifconfig eth2 up
    sleep 30
done


Here is the target json file:

[root@stevo2 ~]# cat /etc/nvmet-10ram.json
{
  "hosts": [],
  "ports": [
    {
      "addr": {
        "adrfam": "ipv4",
        "traddr": "10.0.1.14",
        "treq": "not specified",
        "trsvcid": "4420",
        "trtype": "rdma"
      },
      "portid": 1,
      "referrals": [],
      "subsystems": [
        "test-ram9",
        "test-ram8",
        "test-ram7",
        "test-ram6",
        "test-ram5",
        "test-ram4",
        "test-ram3",
        "test-ram2",
        "test-ram1",
        "test-ram0"
      ]
    },
    {
      "addr": {
        "adrfam": "ipv4",
        "traddr": "10.0.2.14",
        "treq": "not specified",
        "trsvcid": "4420",
        "trtype": "rdma"
      },
      "portid": 2,
      "referrals": [],
      "subsystems": [
        "test-ram9",
        "test-ram8",
        "test-ram7",
        "test-ram6",
        "test-ram5",
        "test-ram4",
        "test-ram3",
        "test-ram2",
        "test-ram1",
        "test-ram0"
      ]
    },
    {
      "addr": {
        "adrfam": "ipv4",
        "traddr": "10.0.5.14",
        "treq": "not specified",
        "trsvcid": "4420",
        "trtype": "rdma"
      },
      "portid": 5,
      "referrals": [],
      "subsystems": [
        "test-ram9",
        "test-ram8",
        "test-ram7",
        "test-ram6",
        "test-ram5",
        "test-ram4",
        "test-ram3",
        "test-ram2",
        "test-ram1",
        "test-ram0"
      ]
    },
    {
      "addr": {
        "adrfam": "ipv4",
        "traddr": "10.0.7.14",
        "treq": "not specified",
        "trsvcid": "4420",
        "trtype": "rdma"
      },
      "portid": 7,
      "referrals": [],
      "subsystems": [
        "test-ram9",
        "test-ram8",
        "test-ram7",
        "test-ram6",
        "test-ram5",
        "test-ram4",
        "test-ram3",
        "test-ram2",
        "test-ram1",
        "test-ram0"
      ]
    }
  ],
  "subsystems": [
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram9"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram9"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram8"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram8"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram7"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram7"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram6"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram6"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram5"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram5"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram4"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram4"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram3"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram3"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram2"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram2"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram1"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram1"
    },
    {
      "allowed_hosts": [],
      "attr": {
        "allow_any_host": "1"
      },
      "namespaces": [
        {
          "device": {
            "nguid": "00000000-0000-0000-0000-000000000000",
            "path": "/dev/ram0"
          },
          "enable": 1,
          "nsid": 1
        }
      ],
      "nqn": "test-ram0"
    }
  ]
}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
