From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: PCI/AER: AER in SRIOV environment
Date: Mon, 23 Jun 2014 17:29:26 +0300
Message-ID: <53A839C6.5050102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vijaymohan.pandarathil-VXdhtT5mjnY@public.gmane.org
Cc: bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, myron.stowe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Vijay,
Trying to add AER support for Mellanox NIC in SRIOV environment, while 
evaluating/testing encountered a problem which led me to your
patch accepted as part of kernel 3.8, commit ID 
"918b4053184c0ca22236e70e299c5343eea35304".

Have some concerns/questions on:
When working in SRIOV environment VFs may be un-attached, having no 
driver assigned to, or may be attached to Virtual machine to work in 
some pass-through mode.
Once working in KVM setup there is pci-stub driver which is loaded in 
the HYP/PF for a given attached VF.

I'm using the aer-inject kernel module and its corresponding aer-inject 
tool to simulate an error in the HYP.
In both cases your commit will cause the AER recovery to fail as there 
is no driver assigned to PF's VFs that supports AER, comparing the code 
before your change.

How such cases should work ?  my expectation was that the PF will get 
the error detected message then will recognize whether
issue is its own or one of its VFs and work accordingly, in current code 
looks like recovery failed as part of "voting" once there is no AER 
handler assigned to the VFs.

Yishai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
