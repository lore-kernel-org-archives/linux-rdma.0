From: Stevie Trujillo <stevie.trujillo@gmail.com>
Subject: "isert: isert_setup_id: rdma_bind_addr() failed: -19" spam,
 followed by Recursive Fault on reboot
Date: Sun, 29 Jan 2017 00:01:24 +0100
Message-ID: <20170129000124.7199b7b5@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Hello

I'm trying (failing) to get iSER working. After rebooting with some settings
saved in targetcli, I got an endless stream of messages like this:

[  192.701299] isert: isert_setup_id: rdma_bind_addr() failed: -19
[  192.702733] isert: isert_setup_id: rdma_bind_addr() failed: -19
[  192.704021] isert: isert_setup_id: rdma_bind_addr() failed: -19
[  192.705458] isert: isert_setup_id: rdma_bind_addr() failed: -19
[  192.706979] isert: isert_setup_id: rdma_bind_addr() failed: -19

I tried deleting everything from targetcli, but the flood would not stop. The
ib_isert module did not unload. When rebooting I got a "Recursive Fault"
with a stacktrace inside configfs.

I hope this is enough information to fix this bug. I assumed the stacktrace
would be saved to the log so I didn't write it down, and I haven't been able to
retrace all the wrong stuff I did trying to make iSER work.

Linux Version: Linux 4.8.15-2~bpo8+2 (Debian 8 Backports)

--
Stevie Trujillo
