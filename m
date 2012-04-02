From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 02 Apr 2012 10:10:34 -0400
Message-ID: <4F79B35A.9070505@dev.mellanox.co.il>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com> <4F798A9B.7060805@acm.org> <4F798B9A.6090309@mellanox.com> <4F799222.3050306@acm.org> <4F79A0C5.2030805@mellanox.com> <4F79A359.2020204@mellanox.com> <4F79A8C4.5000604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F79A8C4.5000604-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart,

On 4/2/2012 9:25 AM, Hal Rosenstock wrote:
> On 4/2/2012 9:02 AM, Or Gerlitz wrote:
>> On 4/2/2012 3:51 PM, Or Gerlitz wrote:
>>> can you add these prints and send me the output after attempting to
>>> cat the rate file?
>>
>> okay, on a system which has IB on port 1 and Ethernet on port 2, using
>> this patch
>> I get these prints:
>>> ib_link_query_port active_speed 4
>>> rate_show ret 0 for ib_query_port dev mlx4_0 port 1 link 1
>>> eth_link_query_port active_speed 4
>>> rate_show ret 0 for ib_query_port dev mlx4_0 port 2 link 2
>>
>> but if forcing port 2 link layer to be IB as well, which means we will
>> land in ib_link_query_port for an Ethernet port, I get the below
>>
>>> echo ib >  /sys/bus/pci/devices/0000:07:00.0/mlx4_port2
>>> ib_link_query_port active_speed 4
>>> rate_show ret 0 for ib_query_port dev mlx4_0 port 1 link 1
>>> ib_link_query_port active_speed 7
>>> rate_show ret 0 for ib_query_port dev mlx4_0 port 2 link 1
>>
>> So when doing the MAD_IFC port info query command on Ethernet port, the
>> firmware returns the
>> value of seven which isn't among the IB speeds and we are remained with
>> rate=-1 in rate_show
>> of drivers/infiniband/core/sysfs.c
> 
> libibumad (and infiniband-diags) are not yet RoCE ready AFAIK. Fixing
> that at least for libibumad is minor. Ira can comment on infiniband-diags.
> 
>> It should be pretty simple to come with patch to that situation, but I
>> want to better understand
>> what happens on your system, waiting for the output...
> 
> I think there are 3 main issues here:
> 1. EINVAL can be returned from rate_show and hence "Invalid argument"
> rate string should be handled in libibumad. I think this was Bart's
> original point.

Would you please try libibumad patch below ? Thanks.

-- Hal

> 2. Why is rate_show returning EINVAL ? I think that's what you're trying
> to isolate with the additional printks you sent Bart for sysfs.c.
> 3. link_layer ethernet should also be handled which is the issue you raised.
> 
> -- Hal
> 
>> Or.

libbibumad/umad.c: In get_port, handle "invalid" rates

where sysfs rate file contains "Invalid argument"

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/umad.c b/src/umad.c
index 45a9423..c638ebd 100644
--- a/src/umad.c
+++ b/src/umad.c
@@ -132,6 +132,7 @@ static int get_port(char *ca_name, char *dir, int portnum, umad_port_t * port)
 	uint8_t gid[16];
 	struct dirent **namelist = NULL;
 	int i, len, num_pkeys = 0;
+	char tmp[24];
 
 	strncpy(port->ca_name, ca_name, sizeof port->ca_name - 1);
 	port->portnum = portnum;
@@ -153,8 +154,13 @@ static int get_port(char *ca_name, char *dir, int portnum, umad_port_t * port)
 		goto clean;
 	if (sys_read_uint(port_dir, SYS_PORT_PHY_STATE, &port->phys_state) < 0)
 		goto clean;
-	if (sys_read_uint(port_dir, SYS_PORT_RATE, &port->rate) < 0)
-		goto clean;
+	if (sys_read_uint(port_dir, SYS_PORT_RATE, &port->rate) < 0) {
+		if (sys_read_string(port_dir, SYS_PORT_RATE, tmp,
+				    sizeof(tmp)) < 0)
+			goto clean;
+		if (strcmp(tmp, strerror(EINVAL)))
+			goto clean;
+	}
 	if (sys_read_uint(port_dir, SYS_PORT_CAPMASK, &port->capmask) < 0)
 		goto clean;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
