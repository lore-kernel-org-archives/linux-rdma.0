From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NFS/RDMA RoCE with mlx4_en
Date: Tue, 27 Jun 2017 12:28:43 -0400
Message-ID: <7FB59BD3-CB33-4710-B049-B53C6C042736@oracle.com>
References: <5E2BFC42-DDA1-4666-BA45-2E33A47C0ED5@oracle.com> <20170627133306.00003fda@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_B7E6B4DA-89EC-4F39-B8F1-5D8629C27191"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170627133306.00003fda-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_B7E6B4DA-89EC-4F39-B8F1-5D8629C27191
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Hi Jack-

Thanks for your help!


> On Jun 27, 2017, at 6:33 AM, jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> On Mon, 26 Jun 2017 13:24:11 -0400
> Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
>> Running various I/O stress workloads with iozone on an
>> NFSv3 mount using RDMA on RoCEv1 (FRWR).
>> 
> Hi Chuck, I have some questions to help us understand what is happening:
> 
> 1. What kernel are you running here?

v4.12-rc2


> 2. What is the underlying Linux distribution?

Oracle Linux 7.3


> 3. What FW is installed on the ConnectX-3 HCA?

2.40.7000


> 4. Is SRIOV enabled? (i.e., is there a line in a modprobe conf file:
>    options mlx4_core num_vfs=<integer greater than zero>

It was enabled in the BIOS, but all lines with "num_vfs=" in these
files are commented out. I disabled the BIOS setting, but no change
in behavior.


> 5. Could you dump the card's .ini file and sent it to us?
>   (flint dc -d <pci bus-dev-fn> dc connectx3.ini)

Attached. Let me know if it doesn't make it.


> 6. Is this a dual-port HCA, Are both ports connected?

Single port.


> 7. Could you try disabling the mlx4 driver automatic driver start at
> boot time?
> 
> 8. After disabling automatic start at boot time, could you reboot the
> host to see if it has problems without the mlx4 driver stack?

I unset CONFIG_CMA. The cma_alloc errors go away, but the mlx4
timeout / reset is unchanged.


> 9. The mlx4 device was reset because a timeout was detected for the
>   DUMP_ETH_STATS command (0x49). The timeout for this command is 60
>   seconds.  Did the message log show anything at around 1 minute before
>   the timeout occurred?

Nothing probative. Lots of "NFS server: not responding".


> 10. Do you know which app is calling cma_alloc?  If you are willing to
> modify your kernel code temporarily for this, you might put a
> stack_dump() in file mm/cma.c at line 454 (where the cma_alloc failure
> line is output).

In the process of collecting data for you, I noticed that
the CX3's maximum Ethernet link speed is 40Gbps, and I
had set the switch port speed to 56Gbps. I've set the
port speed back to 40Gbps, and now neither the device
reset nor the cma_alloc failures are reproducing.

If you'd like to pursue this further, I can switch back to
the higher speed and try to reproduce to collect this
information.


> Thanks, Chuck -- any help you can give us here will be greatly
> appreciated.
> 
> -Jack

--
Chuck Lever



--Apple-Mail=_B7E6B4DA-89EC-4F39-B8F1-5D8629C27191
Content-Disposition: attachment;
	filename=connectx3.ini
Content-Type: application/octet-stream;
	name="connectx3.ini"
Content-Transfer-Encoding: 7bit

;; Generated automatically by iniprep tool on Wed Mar 22 16:01:51 IST 2017 from ./cx3pro_MCX353A_fdr_09v.prs
;;
;; PRS  FILE FOR KESTREL BENTAL
;; $Id$ 



[PS_INFO]
Name = MCX353A-FCC_Ax
Description = ConnectX-3 Pro VPI adapter card; single-port QSFP; FDR IB (56Gb/s) and 40GigE; PCIe3.0 x8 8GT/s
PRS_name    = cx3pro_MCX353A_fdr_09v.prs

[ADAPTER]
PSID = MT_1100111019
pcie_gen2_speed_supported = true
pcie_gen3_speed_supported = true
adapter_dev_id = 0x1007
silicon_rev = 0x00

gpio_mode1 = 0x08000001
gpio_mode0 = 0x04c04032
gpio_default_val = 0x0f306023
gpio_pull_up = 0xff2baf2f
gpio_pull_enable = 0xfbbbbfff

receiver_detect_en = true
vdd_change_to_1_offset = 5

nv_cfg_en = true

nv_config_sectors = 2

[HCA]
hca_header_device_id = 0x1007
hca_header_subsystem_id = 0x0008
hca_header_class_code = 0x28000
eth_xfi_en = true
mdio_en_port1 = 0
pcie_tx_polarity = 0x0f
dpdp_en = true

[IB]
mlpn_en_port0 = true
phy_type_port1 = XFI
ext_phy_board_port1 = FALCON
gen_guids_from_mac = false
do_sense = true
ref_clk_to_use = 0
module_power_level_supported_port0 = 5

num_of_ports = One_Port
new_gpio_scheme_en = true
read_cable_params_port1_en = true

cx3_spec1_3_ib_support_port0 = true
spec1_3_fdr14_ib_support_port0 = true
cx3_spec1_2_ib_support_port0 = true
spec1_3_fdr10_ib_support_port0 = true
mellanox_ddr_ib_support = true
mellanox_qdr_ib_support = true

port1_802_3ap_cr4_enable = true
port1_802_3ap_cr4_ability = true
port1_802_3ap_56kr4_ability = true

center_mix90phase = true

;;Logic lane to Serdes mapping
tx_logic_0_serdes = 0
tx_logic_1_serdes = 1
tx_logic_2_serdes = 2
tx_logic_3_serdes = 3
rx_logic_0_serdes = 3
rx_logic_1_serdes = 2
rx_logic_2_serdes = 1
rx_logic_3_serdes = 0

eth_tx_lane_polarity_port1 = 0xf
eth_rx_lane_polarity_port1 = 0x0
tx_lane_polarity_port1 = 0xf
rx_lane_polarity_port1 = 0x0
; start of '#include "include_QSFP_serdes_prams_bental.h"'

;;Serdes parameters
port0_nego_fdr_mask_en = 0xfffc
port1_nego_fdr_mask_en = 0xfffc
port0_nego_fdr10_mask_en = 0xfffc
port1_nego_fdr10_mask_en = 0xfffc

nego_rx4_slicer_ind_en = 255
nego_rx4_slicer1_enable = 8
nego_rx4_slicer2_enable = 8
nego_rx4_ffe_tap0 = 94
nego_rx4_ffe_tap1 = 134
nego_rx4_ffe_tap2 = 245
nego_rx4_ffe_tap3 = 135
nego_rx4_ffe_tap4 = 171

nego_rx9_ffe_tap0=84
nego_rx9_ffe_tap1=164
nego_rx9_ffe_tap2=251
nego_rx9_ffe_tap3=132
nego_rx9_ffe_tap4=140

nego_rx15_ffe_tap3 = 140
nego_rx15_ffe_tap1 = 140

nego_rx10_ffe_tap3 = 140
nego_rx10_ffe_tap1 = 140

nego_rx8_ffe_tap3 = 140
nego_rx8_ffe_tap1 = 140

force_rx0_slicer_ind_en = 0x0
force_rx0_slicer1_enable = 0x0
force_rx0_slicer2_enable = 0x0
force_rx0_ffe_tap0 = 0xff
force_rx0_ffe_tap1 = 0x80
force_rx0_ffe_tap2 = 0x80
force_rx0_ffe_tap3 = 0x80
force_rx0_ffe_tap4 = 0x80

force_tx0_ob_preemp_pre = 0x40
force_tx0_ob_preemp_post = 0x0
force_tx0_ob_preemp_main = 0x7f
force_tx0_preemp = 0x0
force_tx0_pre_polarity = 0x1
force_tx0_post_polarity = 0x1
force_tx0_main_polarity = 0x0

force_rx2_slicer_ind_en = 0xeb
force_rx2_slicer1_enable = 0x0
force_rx2_slicer2_enable = 0x0
force_rx2_ffe_tap0 = 0x64
force_rx2_ffe_tap1 = 0x80
force_rx2_ffe_tap2 = 0xde
force_rx2_ffe_tap3 = 0x80
force_rx2_ffe_tap4 = 0x46

force_tx2_ob_preemp_pre = 0x30
force_tx2_ob_preemp_post = 0x0
force_tx2_ob_preemp_main = 0x7f
force_tx2_preemp = 0x0
force_tx2_pre_polarity = 0x1
force_tx2_post_polarity = 0x1
force_tx2_main_polarity = 0x0

force_rx3_slicer_ind_en = 0xff
force_rx3_slicer1_enable = 0x8
force_rx3_slicer2_enable = 0x8
force_rx3_ffe_tap0 = 0x6c
force_rx3_ffe_tap1 = 0x80
force_rx3_ffe_tap2 = 0xff
force_rx3_ffe_tap3 = 0x80
force_rx3_ffe_tap4 = 0x80

force_tx3_ob_preemp_pre = 0xc
force_tx3_ob_preemp_post = 0x7f
force_tx3_ob_preemp_main = 0x45
force_tx3_preemp = 0x0
force_tx3_pre_polarity = 0x1
force_tx3_post_polarity = 0x0
force_tx3_main_polarity = 0x1
force_tx3_ob_bias = 0xa

auto_ddr_tx_options = 2
auto_ddr_rx_options = 1

auto_qdr_tx_options = 6
auto_qdr_rx_options = 7

preset_tx_fdr_set12_ob_preemp_pre = 17
preset_tx_fdr_set12_ob_preemp_post = 0
preset_tx_fdr_set12_ob_preemp_main=25
preset_tx_fdr_set12_preemp = 0
preset_tx_fdr_set12_pre_polarity = 1
preset_tx_fdr_set12_post_polarity = 1
preset_tx_fdr_set12_main_polarity = 0
preset_tx_fdr_set12_ob_bias = 5

preset_tx_fdr_set13_ob_preemp_main =40
preset_tx_fdr_set13_ob_preemp_pre = 28
preset_tx_fdr_set13_ob_preemp_post = 0
preset_tx_fdr_set13_preemp = 0
preset_tx_fdr_set13_pre_polarity = 1
preset_tx_fdr_set13_post_polarity = 1
preset_tx_fdr_set13_main_polarity = 0
preset_tx_fdr_set13_ob_bias = 5

preset_tx_fdr_set14_ob_preemp_main = 35
preset_tx_fdr_set14_ob_preemp_pre = 25
preset_tx_fdr_set14_ob_preemp_post = 0
preset_tx_fdr_set14_preemp = 0
preset_tx_fdr_set14_pre_polarity = 1
preset_tx_fdr_set14_post_polarity = 1
preset_tx_fdr_set14_main_polarity = 0
preset_tx_fdr_set14_ob_bias = 5

preset_tx_fdr_set15_ob_preemp_main = 30
preset_tx_fdr_set15_ob_preemp_pre = 20
preset_tx_fdr_set15_ob_preemp_post = 0
preset_tx_fdr_set15_preemp = 0
preset_tx_fdr_set15_pre_polarity = 1
preset_tx_fdr_set15_post_polarity = 1
preset_tx_fdr_set15_main_polarity = 0
preset_tx_fdr_set15_ob_bias = 5

preset_tx_mask = 0xfffe

aba_mask0_start = 0
aba_mask0_end   = 3
aba_mask0 = 0x1000
aba_mask1_start = 4
aba_mask1_end   = 5
aba_mask1 = 0x8000
aba_mask2_start = 6
aba_mask2_end   = 10
aba_mask2 = 0x4000
aba_mask3_start = 11
aba_mask3_end   = 16
aba_mask3 = 0x2000

; ABA 40GE
aba_tx2_ob_preemp_pre = 20
aba_tx2_ob_preemp_main = 42
aba_tx2_ob_preemp_post = 8
aba_tx2_ob_bias = 8
aba_tx2_pre_polarity = 1
aba_tx2_post_polarity = 1
aba_tx2_main_polarity = 0

;;3m
aba_tx3_ob_preemp_pre = 22
aba_tx3_ob_preemp_main = 42
aba_tx3_ob_preemp_post = 5
aba_tx3_ob_bias = 8
aba_tx3_pre_polarity = 1
aba_tx3_post_polarity = 1
aba_tx3_main_polarity = 0

aba_tx4_ob_preemp_pre = 26
aba_tx4_ob_preemp_main = 42
aba_tx4_ob_preemp_post = 3
aba_tx4_ob_bias = 8
aba_tx4_pre_polarity = 1
aba_tx4_post_polarity = 1
aba_tx4_main_polarity = 0

aba_tx5_ob_preemp_pre = 60
aba_tx5_ob_preemp_main = 90
aba_tx5_ob_preemp_post = 8
aba_tx5_ob_bias = 8
aba_tx5_pre_polarity = 1
aba_tx5_post_polarity = 1
aba_tx5_main_polarity = 0

aba_tx6_ob_preemp_pre = 80
aba_tx6_ob_preemp_main = 110
aba_tx6_ob_preemp_post = 10
aba_tx6_ob_bias = 8
aba_tx6_pre_polarity = 1
aba_tx6_post_polarity = 1
aba_tx6_main_polarity = 0

aba_tx7_ob_preemp_pre = 75
aba_tx7_ob_preemp_main = 110
aba_tx7_ob_preemp_post = 15
aba_tx7_ob_bias = 8
aba_tx7_pre_polarity = 1
aba_tx7_post_polarity = 1
aba_tx7_main_polarity = 0

aba_fdr_tx16_ob_preemp_pre = 17
aba_fdr_tx16_ob_preemp_post = 0
aba_fdr_tx16_ob_preemp_main=25
aba_fdr_tx16_preemp = 0
aba_fdr_tx16_pre_polarity = 1
aba_fdr_tx16_post_polarity = 1
aba_fdr_tx16_main_polarity = 0
aba_fdr_tx16_ob_bias = 5

aba_fdr_tx17_ob_preemp_main =46
aba_fdr_tx17_ob_preemp_pre = 32
aba_fdr_tx17_ob_preemp_post = 0
aba_fdr_tx17_preemp = 0
aba_fdr_tx17_pre_polarity = 1
aba_fdr_tx17_post_polarity = 1
aba_fdr_tx17_main_polarity = 0
aba_fdr_tx17_ob_bias = 3

aba_fdr_tx18_ob_preemp_main = 50
aba_fdr_tx18_ob_preemp_pre = 32
aba_fdr_tx18_ob_preemp_post = 0
aba_fdr_tx18_preemp = 0
aba_fdr_tx18_pre_polarity = 1
aba_fdr_tx18_post_polarity = 1
aba_fdr_tx18_main_polarity = 0
aba_fdr_tx18_ob_bias = 3

aba_fdr_tx19_ob_preemp_main = 60
aba_fdr_tx19_ob_preemp_pre = 30
aba_fdr_tx19_ob_preemp_post = 0
aba_fdr_tx19_preemp = 0
aba_fdr_tx19_pre_polarity = 1
aba_fdr_tx19_post_polarity = 1
aba_fdr_tx19_main_polarity = 0
aba_fdr_tx19_ob_bias = 3

aba_index0_start = 0
aba_index0_end   = 3
aba_index0 = 0
aba_index1_start = 4
aba_index1_end   = 5
aba_index1 = 3
aba_index2_start = 6
aba_index2_end   = 9
aba_index2 = 2
aba_index3_start = 10
aba_index3_end   = 16
aba_index3 = 1

aba_rx2_slicer_ind_en = 0xeb
aba_rx2_slicer1_enable = 0x0
aba_rx2_slicer2_enable = 0x0
aba_rx2_ffe_tap0 = 0x80
aba_rx2_ffe_tap1 = 0x68
aba_rx2_ffe_tap2 = 0xd7
aba_rx2_ffe_tap3 = 0x80
aba_rx2_ffe_tap4 = 0x5a

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; SFP+ section. all QSFP can be converted to SFP+ using QSA adapter.;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ETH connected to third party device
aba_non_mlpn_tx8_ob_preemp_pre = 5
aba_non_mlpn_tx8_ob_preemp_post = 0
aba_non_mlpn_tx8_ob_preemp_main = 65
aba_non_mlpn_tx8_ob_bias = 8
aba_non_mlpn_tx8_pre_polarity = 1
aba_non_mlpn_tx8_post_polarity = 1
aba_non_mlpn_tx8_main_polarity = 0
aba_non_mlpn_tx8_preemp = 0


nego_eth_rx12_slicer_ind_en = 0xff
nego_eth_rx12_slicer1_enable= 0x8
nego_eth_rx12_slicer2_enable= 0x8
nego_eth_rx12_ffe_tap0=241
nego_eth_rx12_ffe_tap1=128
nego_eth_rx12_ffe_tap2=61
nego_eth_rx12_ffe_tap3=99
nego_eth_rx12_ffe_tap4=128

; end of '#include "include_QSFP_serdes_prams_bental.h"'

[PLL]
lbist_en  = 0
lbist_shift_freq  = 3
flash_div = 0x3
lbist_array_bypass = 1
lbist_pat_cnt_lsb = 0x2
core_f = 60
core_r = 14
core_od = 2
en_427_mhz = true

[FW]
flash_has_suspend_resume = 0
log_flashdev_size = 21
log_flash_sector_size = 2

--Apple-Mail=_B7E6B4DA-89EC-4F39-B8F1-5D8629C27191--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
