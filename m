From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx5 endpoint driver problem
Date: Wed, 10 May 2017 16:16:10 +0100
Message-ID: <9f624a9c-ada0-eb3e-72cc-d851fdc6e433@synopsys.com>
References: <f0b8881d-9aa3-8816-7ea6-daccc0e91262@synopsys.com>
 <18d3cc2e-e235-6ae4-cd69-b5a11d607ee4@synopsys.com>
 <AM4PR0501MB278757CE912385F3B3324CE7C5EC0@AM4PR0501MB2787.eurprd05.prod.outlook.com>
 <a3f77d2c-086b-91bf-8dc8-e3d60dcce791@synopsys.com>
 <AM4PR0501MB27873B51842616191FEEFE3BC5EC0@AM4PR0501MB2787.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AM4PR0501MB27873B51842616191FEEFE3BC5EC0-dp/nxUn679jFcPxmzbbP+MDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Às 4:14 PM de 5/10/2017, Eli Cohen escreveu:
> How many CPU cores do you have?

I just have 1 core. I commented the affinity functions from mxl5/main.c and
requested my colegue that has the Endpoint with good firmware to validate if it
can initialize well the device. In your opinion it should work, right?

Joao

> 
> -----Original Message-----
> From: Joao Pinto [mailto:Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org] 
> Sent: Wednesday, May 10, 2017 10:01 AM
> To: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: mlx5 endpoint driver problem
> 
> 
> Hi Eli,
> 
> Às 3:56 PM de 5/10/2017, Eli Cohen escreveu:
>> Hi Joao,
>>
>>
>>
>> Since mlx5 supported devices can do DMA with 64 bit addresses we start like this. This fails in your system since it is not capable of handling 64 bit addresses so we fall back to 32 bit addresses which then succeed. However what you are experiencing is the driver executed a command and firmware supposedly does not respond. Most likely the firmware responded but the driver could not see it due to problems related to dma addresses in your system.
>>
>>
>>
>> Long story short, there is a problem in your system. To investigate this further you might need heavy tools such as pcie analyzer.
>>
> 
> 
>>
>>
> 
> I have new data for you. My colleague is using a Mellanox MT27800 Family
> (ConnectX-5) with Firmware version 16.19.148 and it does not have hangs, but it fails in the CPU mask:
> 
> mlx5_core 0000:01:00.0: enabling device (0000 -> 0002) mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit PCI DMA mask mlx5_core 0000:01:00.0: Warning: couldn't set 64-bit consistent PCI DMA mask mlx5_core 0000:01:00.0: firmware version: 16.19.148 mlx5_core 0000:01:00.0: Port module event: module 0, Cable unplugged mlx5_core 0000:01:00.0: mlx5_irq_set_affinity_hint:628:(pid 1):
> irq_set_affinity_hint failed,irq 0x0032
> mlx5_core 0000:01:00.0: Failed to alloc affinity hint cpumask mlx5_core 0000:01:00.0: mlx5_load_one failed with error code -22
> mlx5_core: probe of 0000:01:00.0 failed with error -22
> 
> Mine is a Mellanox MT28800 Family (ConnectX-5) with Firmware Version 16.19.21102. I think I have some firmware problem.
> 
> The affinity problem might be due to my Root Complex driver does not support affinity at the moment.
> 
> Thanks,
> Joao
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
