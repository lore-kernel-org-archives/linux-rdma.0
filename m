From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Tue, 5 Apr 2016 02:43:39 -0700
Message-ID: <20160405094339.GA1622@infradead.org>
References: <20160404134656.GA30269@infradead.org>
 <5702A46F.5070109@grimberg.me>
 <5702A6AC.9020008@grimberg.me>
 <20160404225831.GA6725@infradead.org>
 <57037D8E.4030506@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57037D8E.4030506-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 05, 2016 at 11:55:42AM +0300, sagig wrote:
> This implies that maybe something broke in ib_sg_to_pages:
> 
> Can you run iser with this patch applied (FR or FMR):

For FMR this won't trigger, but here is the FR run:

[   63.016616] iser: iser_fast_reg_mr: failed to map sg (101/102)
[   63.023183] iser: iser_data_buf_dump: sg[0] dma_addr:0x90E15D200
page:0xffffea0024385740 off:0x200 sz:0xe00 dma_len:0xe00
[   63.035466] iser: iser_data_buf_dump: sg[1] dma_addr:0x90611D000
page:0xffffea0024184740 off:0x0 sz:0x1000 dma_len:0x1000
[   63.047749] iser: iser_data_buf_dump: sg[2] dma_addr:0x90EDB3000
page:0xffffea00243b6cc0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.060050] iser: iser_data_buf_dump: sg[3] dma_addr:0x9062CB000
page:0xffffea002418b2c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.072328] iser: iser_data_buf_dump: sg[4] dma_addr:0x9061EA000
page:0xffffea0024187a80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.084614] iser: iser_data_buf_dump: sg[5] dma_addr:0x90E7D2000
page:0xffffea002439f480 off:0x0 sz:0x1000 dma_len:0x1000
[   63.096907] iser: iser_data_buf_dump: sg[6] dma_addr:0x90E5EF000
page:0xffffea0024397bc0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.109195] iser: iser_data_buf_dump: sg[7] dma_addr:0x90B755000
page:0xffffea00242dd540 off:0x0 sz:0x1000 dma_len:0x1000
[   63.121487] iser: iser_data_buf_dump: sg[8] dma_addr:0x9016F2000
page:0xffffea002405bc80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.133780] iser: iser_data_buf_dump: sg[9] dma_addr:0x906194000
page:0xffffea0024186500 off:0x0 sz:0x1000 dma_len:0x1000
[   63.146074] iser: iser_data_buf_dump: sg[10] dma_addr:0x9017A2000
page:0xffffea002405e880 off:0x0 sz:0x1000 dma_len:0x1000
[   63.158456] iser: iser_data_buf_dump: sg[11] dma_addr:0x92D4BC000
page:0xffffea0024b52f00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.170841] iser: iser_data_buf_dump: sg[12] dma_addr:0x92D4BF000
page:0xffffea0024b52fc0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.183233] iser: iser_data_buf_dump: sg[13] dma_addr:0x93FA69000
page:0xffffea0024fe9a40 off:0x0 sz:0x1000 dma_len:0x1000
[   63.195608] iser: iser_data_buf_dump: sg[14] dma_addr:0x90E011000
page:0xffffea0024380440 off:0x0 sz:0x1000 dma_len:0x1000
[   63.208082] iser: iser_data_buf_dump: sg[15] dma_addr:0x90EACD000
page:0xffffea00243ab340 off:0x0 sz:0x1000 dma_len:0x1000
[   63.220499] iser: iser_data_buf_dump: sg[16] dma_addr:0x93FA6A000
page:0xffffea0024fe9a80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.232916] iser: iser_data_buf_dump: sg[17] dma_addr:0x93FD23000
page:0xffffea0024ff48c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.245334] iser: iser_data_buf_dump: sg[18] dma_addr:0x903D57000
page:0xffffea00240f55c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.257748] iser: iser_data_buf_dump: sg[19] dma_addr:0x93FF38000
page:0xffffea0024ffce00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.270167] iser: iser_data_buf_dump: sg[20] dma_addr:0x90F035000
page:0xffffea00243c0d40 off:0x0 sz:0x1000 dma_len:0x1000
[   63.282584] iser: iser_data_buf_dump: sg[21] dma_addr:0x901719000
page:0xffffea002405c640 off:0x0 sz:0x1000 dma_len:0x1000
[   63.295000] iser: iser_data_buf_dump: sg[22] dma_addr:0x90EBA3000
page:0xffffea00243ae8c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.307422] iser: iser_data_buf_dump: sg[23] dma_addr:0x90E20B000
page:0xffffea00243882c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.319837] iser: iser_data_buf_dump: sg[24] dma_addr:0x901722000
page:0xffffea002405c880 off:0x0 sz:0x1000 dma_len:0x1000
[   63.332255] iser: iser_data_buf_dump: sg[25] dma_addr:0x93FA52000
page:0xffffea0024fe9480 off:0x0 sz:0x1000 dma_len:0x1000
[   63.344679] iser: iser_data_buf_dump: sg[26] dma_addr:0x90E023000
page:0xffffea00243808c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.357095] iser: iser_data_buf_dump: sg[27] dma_addr:0x901679000
page:0xffffea0024059e40 off:0x0 sz:0x1000 dma_len:0x1000
[   63.369518] iser: iser_data_buf_dump: sg[28] dma_addr:0x90DC4A000
page:0xffffea0024371280 off:0x0 sz:0x1000 dma_len:0x1000
[   63.381937] iser: iser_data_buf_dump: sg[29] dma_addr:0x90160D000
page:0xffffea0024058340 off:0x0 sz:0x1000 dma_len:0x1000
[   63.394353] iser: iser_data_buf_dump: sg[30] dma_addr:0x90E9F3000
page:0xffffea00243a7cc0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.406769] iser: iser_data_buf_dump: sg[31] dma_addr:0x90E6CA000
page:0xffffea002439b280 off:0x0 sz:0x1000 dma_len:0x1000
[   63.419175] iser: iser_data_buf_dump: sg[32] dma_addr:0x90E6DA000
page:0xffffea002439b680 off:0x0 sz:0x1000 dma_len:0x1000
[   63.431596] iser: iser_data_buf_dump: sg[33] dma_addr:0x901787000
page:0xffffea002405e1c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.444013] iser: iser_data_buf_dump: sg[34] dma_addr:0x90E6A7000
page:0xffffea002439a9c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.456430] iser: iser_data_buf_dump: sg[35] dma_addr:0x90178C000
page:0xffffea002405e300 off:0x0 sz:0x1000 dma_len:0x1000
[   63.468853] iser: iser_data_buf_dump: sg[36] dma_addr:0x90E27A000
page:0xffffea0024389e80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.481278] iser: iser_data_buf_dump: sg[37] dma_addr:0x90E6CC000
page:0xffffea002439b300 off:0x0 sz:0x1000 dma_len:0x1000
[   63.493702] iser: iser_data_buf_dump: sg[38] dma_addr:0x90E6CF000
page:0xffffea002439b3c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.506116] iser: iser_data_buf_dump: sg[39] dma_addr:0x901790000
page:0xffffea002405e400 off:0x0 sz:0x1000 dma_len:0x1000
[   63.518531] iser: iser_data_buf_dump: sg[40] dma_addr:0x90E6D0000
page:0xffffea002439b400 off:0x0 sz:0x1000 dma_len:0x1000
[   63.530955] iser: iser_data_buf_dump: sg[41] dma_addr:0x90E6D6000
page:0xffffea002439b580 off:0x0 sz:0x1000 dma_len:0x1000
[   63.543370] iser: iser_data_buf_dump: sg[42] dma_addr:0x92D266000
page:0xffffea0024b49980 off:0x0 sz:0x1000 dma_len:0x1000
[   63.555778] iser: iser_data_buf_dump: sg[43] dma_addr:0x90177B000
page:0xffffea002405dec0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.568886] iser: iser_data_buf_dump: sg[44] dma_addr:0x92D265000
page:0xffffea0024b49940 off:0x0 sz:0x1000 dma_len:0x1000
[   63.581950] iser: iser_data_buf_dump: sg[45] dma_addr:0x90E240000
page:0xffffea0024389000 off:0x0 sz:0x1000 dma_len:0x1000
[   63.595005] iser: iser_data_buf_dump: sg[46] dma_addr:0x901635000
page:0xffffea0024058d40 off:0x0 sz:0x1000 dma_len:0x1000
[   63.608022] iser: iser_data_buf_dump: sg[47] dma_addr:0x9062B8000
page:0xffffea002418ae00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.620986] iser: iser_data_buf_dump: sg[48] dma_addr:0x90EACF000
page:0xffffea00243ab3c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.633939] iser: iser_data_buf_dump: sg[49] dma_addr:0x901631000
page:0xffffea0024058c40 off:0x0 sz:0x1000 dma_len:0x1000
[   63.646887] iser: iser_data_buf_dump: sg[50] dma_addr:0x90E8DE000
page:0xffffea00243a3780 off:0x0 sz:0x1000 dma_len:0x1000
[   63.659842] iser: iser_data_buf_dump: sg[51] dma_addr:0x9034F4000
page:0xffffea00240d3d00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.672794] iser: iser_data_buf_dump: sg[52] dma_addr:0x903CF7000
page:0xffffea00240f3dc0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.685744] iser: iser_data_buf_dump: sg[53] dma_addr:0x90E511000
page:0xffffea0024394440 off:0x0 sz:0x1000 dma_len:0x1000
[   63.698371] iser: iser_data_buf_dump: sg[54] dma_addr:0x90F328000
page:0xffffea00243cca00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.711008] iser: iser_data_buf_dump: sg[55] dma_addr:0x90E3BC000
page:0xffffea002438ef00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.723643] iser: iser_data_buf_dump: sg[56] dma_addr:0x90F32E000
page:0xffffea00243ccb80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.736277] iser: iser_data_buf_dump: sg[57] dma_addr:0x90F323000
page:0xffffea00243cc8c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.748893] iser: iser_data_buf_dump: sg[58] dma_addr:0x9064CD000
page:0xffffea0024193340 off:0x0 sz:0x1000 dma_len:0x1000
[   63.761509] iser: iser_data_buf_dump: sg[59] dma_addr:0x90169F000
page:0xffffea002405a7c0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.774127] iser: iser_data_buf_dump: sg[60] dma_addr:0x9062B4000
page:0xffffea002418ad00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.786744] iser: iser_data_buf_dump: sg[61] dma_addr:0x90310A000
page:0xffffea00240c4280 off:0x0 sz:0x1000 dma_len:0x1000
[   63.799371] iser: iser_data_buf_dump: sg[62] dma_addr:0x93FE24000
page:0xffffea0024ff8900 off:0x0 sz:0x1000 dma_len:0x1000
[   63.811990] iser: iser_data_buf_dump: sg[63] dma_addr:0x9063BA000
page:0xffffea002418ee80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.824608] iser: iser_data_buf_dump: sg[64] dma_addr:0x903CFC000
page:0xffffea00240f3f00 off:0x0 sz:0x1000 dma_len:0x1000
[   63.837228] iser: iser_data_buf_dump: sg[65] dma_addr:0x903106000
page:0xffffea00240c4180 off:0x0 sz:0x1000 dma_len:0x1000
[   63.849835] iser: iser_data_buf_dump: sg[66] dma_addr:0x90B93F000
page:0xffffea00242e4fc0 off:0x0 sz:0x1000 dma_len:0x1000
[   63.862455] iser: iser_data_buf_dump: sg[67] dma_addr:0x90E9C9000
page:0xffffea00243a7240 off:0x0 sz:0x1000 dma_len:0x1000
[   63.875073] iser: iser_data_buf_dump: sg[68] dma_addr:0x90176D000
page:0xffffea002405db40 off:0x0 sz:0x1000 dma_len:0x1000
[   63.887689] iser: iser_data_buf_dump: sg[69] dma_addr:0x90177E000
page:0xffffea002405df80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.900308] iser: iser_data_buf_dump: sg[70] dma_addr:0x90E501000
page:0xffffea0024394040 off:0x0 sz:0x1000 dma_len:0x1000
[   63.912926] iser: iser_data_buf_dump: sg[71] dma_addr:0x9016FE000
page:0xffffea002405bf80 off:0x0 sz:0x1000 dma_len:0x1000
[   63.925549] iser: iser_data_buf_dump: sg[72] dma_addr:0x9014F5000
page:0xffffea0024053d40 off:0x0 sz:0x1000 dma_len:0x1000
[   63.938165] iser: iser_data_buf_dump: sg[73] dma_addr:0x90EB96000
page:0xffffea00243ae580 off:0x0 sz:0x2000 dma_len:0x2000
[   63.950779] iser: iser_data_buf_dump: sg[74] dma_addr:0x90E22E000
page:0xffffea0024388b80 off:0x0 sz:0x2000 dma_len:0x2000
[   63.963400] iser: iser_data_buf_dump: sg[75] dma_addr:0x901636000
page:0xffffea0024058d80 off:0x0 sz:0x2000 dma_len:0x2000
[   63.976015] iser: iser_data_buf_dump: sg[76] dma_addr:0x90169C000
page:0xffffea002405a700 off:0x0 sz:0x2000 dma_len:0x2000
[   63.988629] iser: iser_data_buf_dump: sg[77] dma_addr:0x90163A000
page:0xffffea0024058e80 off:0x0 sz:0x2000 dma_len:0x2000
[   64.001238] iser: iser_data_buf_dump: sg[78] dma_addr:0x90177C000
page:0xffffea002405df00 off:0x0 sz:0x2000 dma_len:0x2000
[   64.013852] iser: iser_data_buf_dump: sg[79] dma_addr:0x903FBE000
page:0xffffea00240fef80 off:0x0 sz:0x2000 dma_len:0x2000
[   64.026462] iser: iser_data_buf_dump: sg[80] dma_addr:0x9061B6000
page:0xffffea0024186d80 off:0x0 sz:0x2000 dma_len:0x2000
[   64.039077] iser: iser_data_buf_dump: sg[81] dma_addr:0x90E7FA000
page:0xffffea002439fe80 off:0x0 sz:0x2000 dma_len:0x2000
[   64.051697] iser: iser_data_buf_dump: sg[82] dma_addr:0x90E9D4000
page:0xffffea00243a7500 off:0x0 sz:0x2000 dma_len:0x2000
[   64.064310] iser: iser_data_buf_dump: sg[83] dma_addr:0x90E502000
page:0xffffea0024394080 off:0x0 sz:0x2000 dma_len:0x2000
[   64.076933] iser: iser_data_buf_dump: sg[84] dma_addr:0x901686000
page:0xffffea002405a180 off:0x0 sz:0x2000 dma_len:0x2000
[   64.089548] iser: iser_data_buf_dump: sg[85] dma_addr:0x903458000
page:0xffffea00240d1600 off:0x0 sz:0x2000 dma_len:0x2000
[   64.102163] iser: iser_data_buf_dump: sg[86] dma_addr:0x90E43A000
page:0xffffea0024390e80 off:0x0 sz:0x2000 dma_len:0x2000
[   64.114779] iser: iser_data_buf_dump: sg[87] dma_addr:0x90F190000
page:0xffffea00243c6400 off:0x0 sz:0x2000 dma_len:0x2000
[   64.127395] iser: iser_data_buf_dump: sg[88] dma_addr:0x9016F6000
page:0xffffea002405bd80 off:0x0 sz:0x2000 dma_len:0x2000
[   64.140002] iser: iser_data_buf_dump: sg[89] dma_addr:0x92D3AC000
page:0xffffea0024b4eb00 off:0x0 sz:0x2000 dma_len:0x2000
[   64.152621] iser: iser_data_buf_dump: sg[90] dma_addr:0x903F86000
page:0xffffea00240fe180 off:0x0 sz:0x2000 dma_len:0x2000
[   64.165239] iser: iser_data_buf_dump: sg[91] dma_addr:0x901598000
page:0xffffea0024056600 off:0x0 sz:0x2000 dma_len:0x2000
[   64.177857] iser: iser_data_buf_dump: sg[92] dma_addr:0x90F7D4000
page:0xffffea00243df500 off:0x0 sz:0x2000 dma_len:0x2000
[   64.190476] iser: iser_data_buf_dump: sg[93] dma_addr:0x90E31E000
page:0xffffea002438c780 off:0x0 sz:0x2000 dma_len:0x2000
[   64.203147] iser: iser_data_buf_dump: sg[94] dma_addr:0x90E31A000
page:0xffffea002438c680 off:0x0 sz:0x2000 dma_len:0x2000
[   64.215764] iser: iser_data_buf_dump: sg[95] dma_addr:0x90E440000
page:0xffffea0024391000 off:0x0 sz:0x2000 dma_len:0x2000
[   64.228380] iser: iser_data_buf_dump: sg[96] dma_addr:0x90E43E000
page:0xffffea0024390f80 off:0x0 sz:0x2000 dma_len:0x2000
[   64.240995] iser: iser_data_buf_dump: sg[97] dma_addr:0x901586000
page:0xffffea0024056180 off:0x0 sz:0x2000 dma_len:0x2000
[   64.253611] iser: iser_data_buf_dump: sg[98] dma_addr:0x90F390000
page:0xffffea00243ce400 off:0x0 sz:0x2000 dma_len:0x2000
[   64.266219] iser: iser_data_buf_dump: sg[99] dma_addr:0x90660E000
page:0xffffea0024198380 off:0x0 sz:0x2000 dma_len:0x2000
[   64.278836] iser: iser_data_buf_dump: sg[100] dma_addr:0x9017E6000
page:0xffffea002405f980 off:0x0 sz:0x1000 dma_len:0x1000
[   64.291577] iser: iser_data_buf_dump: sg[101] dma_addr:0x93FBF1000
page:0xffffea0024fefc40 off:0x0 sz:0x200 dma_len:0x200

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
