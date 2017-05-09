From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: mlx5 endpoint driver problem
Date: Tue, 9 May 2017 18:13:10 +0100
Message-ID: <18d3cc2e-e235-6ae4-cd69-b5a11d607ee4@synopsys.com>
References: <f0b8881d-9aa3-8816-7ea6-daccc0e91262@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0b8881d-9aa3-8816-7ea6-daccc0e91262-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Hello,

I am making tests with a Mellanox MLX5 Endpoint, and I am getting kernel hangs
when trying to enable the hca:

mlx5_core 0000:01:00.0: enabling device (0000 -> 0002)
mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit PCI DMA mask
mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit consistent PCI DMA mask
mlx5_core 0000:01:00.0: firmware version: 16.19.21102
INFO: task swapper:1 blocked for more than 10 seconds.
      Not tainted 4.11.0-BETAMSIX1 #51
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
swapper         D    0     1      0 0x00000000

Stack Trace:
  __switch_to+0x0/0x94
  __schedule+0x1da/0x8b0
  schedule+0x26/0x6c
  schedule_timeout+0x2da/0x380
  wait_for_completion+0x92/0x104
  mlx5_cmd_exec+0x70e/0xd60
  mlx5_load_one+0x1b4/0xad8
  init_one+0x404/0x600
  pci_device_probe+0x122/0x1f0
  really_probe+0x1ac/0x348
  __driver_attach+0xa8/0xd0
  bus_for_each_dev+0x3c/0x74
  bus_add_driver+0xc2/0x184
  driver_register+0x50/0xec
  init+0x40/0x60

(...)

Stack Trace:
  __switch_to+0x0/0x94
  __schedule+0x1da/0x8b0
  schedule+0x26/0x6c
  schedule_timeout+0x2da/0x380
  wait_for_completion+0x92/0x104
  mlx5_cmd_exec+0x70e/0xd60
  mlx5_load_one+0x1b4/0xad8
  init_one+0x404/0x600
  pci_device_probe+0x122/0x1f0
  really_probe+0x1ac/0x348
  __driver_attach+0xa8/0xd0
  bus_for_each_dev+0x3c/0x74
  bus_add_driver+0xc2/0x184
  driver_register+0x50/0xec
  init+0x40/0x60
mlx5_core 0000:01:00.0: wait_func:882:(pid 1): ENABLE_HCA(0x104) timeout. Will
cause a leak of a command resource
mlx5_core 0000:01:00.0: enable hca failed
mlx5_core 0000:01:00.0: mlx5_load_one failed with error code -110
mlx5_core: probe of 0000:01:00.0 failed with error -110

Could you give me a clue of what might be happennig?

Thanks,
Joao
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
