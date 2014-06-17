From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 78181] New: pci_disable_device() shouldn't be called when the
 call to pci_enable_device() fails.
Date: Tue, 17 Jun 2014 12:55:52 +0000
Message-ID: <bug-78181-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=78181

            Bug ID: 78181
           Summary: pci_disable_device() shouldn't be called when the call
                    to pci_enable_device() fails.
           Product: Drivers
           Version: 2.5
    Kernel Version: 2.6.39
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: rucsoftsec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
        Regression: No

In function twa_probe() at drivers/scsi/3w-9xxx.c:2030, the call to
pci_disable_device() at line 2173 is after the failure of pci_enable_device().
it may be wrong.
The related code snippets in function twa_probe() are as followings.
twa_probe @ drivers/scsi/3w-9xxx.c:2030
2030 static int __devinit twa_probe(struct pci_dev *pdev, const struct
pci_device_id *dev_id)
2031 {
2032         struct Scsi_Host *host = NULL;
2033         TW_Device_Extension *tw_dev;
2034         unsigned long mem_addr, mem_len;
2035         int retval = -ENODEV;
2036 
2037         retval = pci_enable_device(pdev);
2038         if (retval) {
2039                 TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci
device");
2040                 goto out_disable_device;
2041         }
2042 
     ...
2169 out_free_device_extension:
2170         twa_free_device_extension(tw_dev);
2171         scsi_host_put(host);
2172 out_disable_device:
2173         pci_disable_device(pdev);
2174 
2175         return retval;
2176 }

Generally, the call to pci_disable_device() shall be after the successful call
to pci_enable_device(), like the following code snippets in function
c2_probe().
c2_probe @ drivers/infiniband/hw/amso1100/c2.c:924
924 static int __devinit c2_probe(struct pci_dev *pcidev,
925                               const struct pci_device_id *ent)
926 {
927         int ret = 0, i;
928         unsigned long reg0_start, reg0_flags, reg0_len;
    ...
940         ret = pci_enable_device(pcidev);
941         if (ret) {
942                 printk(KERN_ERR PFX "%s: Unable to enable PCI device\n",
943                         pci_name(pcidev));
944                 goto bail0;
945         }
     ...
1187 
1188  bail1:
1189         pci_disable_device(pcidev);
1190 
1191  bail0:
1192         return ret;
1193 }

the above suspect bug exists in function twl_probe() at drivers/scsi/3w-sas.c
and function qla2x00_probe_one() at drivers/scsi/qla2xxx/qla_os.c.
Thak you!

RUC_Soft_Sec, supported by China.X.Orion

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
